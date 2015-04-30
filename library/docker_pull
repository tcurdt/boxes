#!/usr/bin/python
# vim:fileencoding=utf-8

DOCUMENTATION = """
---
module: docker_pull
short_description: Pulls docker images
description:
  - Pulls specific docker images onto hosts, and deletes old
    versions of images.
version_added: "0.1"
author: Dan Buch & contributors
options:
  state:
    description:
      - Does nothing, defaults to present, no other options.
    required: false
    default: present
  repo:
    description:
      - The repo to be pulled on to a host.
      - Specify a 'tag' if all of the images for this repo should not be
        pulled.
    required: true
    default: null
  tag:
    description:
      - Image tag, use this if you want to pull only a single image.
    required: false
    default: null
  keep_images:
    description:
      - Keep the first N images based on chronological order, and remove any
        older images. By default, this is not enable.
      - Removal of images occurs before the desired image is pulled.
      - If any of the images that should be removed are running containers,
        they will be skipped for removal.
    required: false
    default: -1
"""

EXAMPLES = """
# Pull a particular redis image.
- docker_pull:
    repo: "redis"
    tag:  "2.8.13"

# Keep only the 3 newest images of this repo and remove all older images,
# in addition to pulling the particular redis image.
- docker_pull:
    repo:         "redis"
    tag:          "2.8.13"
    keep_images:  3
"""

import re

from collections import OrderedDict
from hashlib import md5


class DockerPuller(object):

    def __init__(self, module):
        self.module = module
        self.repo = module.params['repo']
        self.tag = module.params['tag']
        self.keep_images = int(module.params['keep_images'])

    def pull_repo(self, docker='docker'):
        checksum = self._get_images_checksum(docker)
        cmd = [self._docker(docker), 'pull']

        repo = self.repo
        if self.tag:
            repo += ':' + self.tag

        cmd += [repo]

        rc, out, err = self._run(cmd)

        if rc is not None and rc != 0:
            self._fail(err, rc)

        if out.strip().startswith('Usage:'):
            self._fail(
                ('Got usage output for cmd=%r:\n' % (cmd,)) + out + err, rc
            )

        return (
            (rc, out, err),
            self._get_images_checksum(docker) != checksum
        )

    def _get_images_checksum(self, docker='docker'):
        cmd = [self._docker(docker), 'images', '-q']
        rc, out, err = self._run(cmd)

        if rc is not None and rc != 0:
            self._fail(err, rc)

        return _md5sum(out.strip())

    def remove_old_images(self):
        images = self._exec_docker(['images'])
        old_images = self._image_ids_for_removal(images)

        if old_images:
            # Appending the list of images to be deleted to cmd because
            # each of the images is a parameter to the docker rmi command.
            args = ['rmi'] + old_images
            self._exec_docker(args)

    def _image_ids_for_removal(self, input_text):
        """
        From the output of 'docker images':
          Obtain the lines that contain the repo that will be pulled.
          From those lines, obtain the image ids.
          From this set of image ids, remove any repeated ids.
          Additionally, remove any images from the set that are associated
          with existing containers.

          If there are more unique image ids than the 'keep_images' limit,
          remove the first N images from unique_image_ids, where N is
          'keep_images', and return the resultant set.
        """

        lines = re.split('\n', input_text)
        lines = [re.split('\s\s+', line) for line in lines]
        # docker images columns:
        #     repo, tag, image_id, created, size
        lines = [line for line in lines if self.repo == line[0]]
        image_ids = [line[2] for line in lines]
        unique_image_ids = OrderedDict.fromkeys(image_ids).keys()

        running_images = self._get_container_image_ids()
        removable_image_ids = [image_id for image_id in unique_image_ids
                               if image_id not in running_images]

        if len(removable_image_ids) > self.keep_images:
            for i in range(self.keep_images):
                removable_image_ids.pop(0)
            return removable_image_ids

    def _get_container_image_ids(self):
        """
        Return the image ids for running and stopped containers.
        """

        lines = self._exec_docker(['ps', '-a'])
        lines = re.split('\n', lines)
        # Removing the header line.
        lines = lines[1:]
        lines = [line.strip() for line in lines]
        lines = [re.split('\s\s+', line) for line in lines]
        # docker ps columns:
        #     container id, image, command, created, status, ports, names
        # Note: ports can be an empty column.
        image_ids = [self._get_container_image_id(line[0]) for line in lines
                     if len(line) == 7 or len(line) == 6]
        return OrderedDict.fromkeys(image_ids).keys()

    def _get_container_image_id(self, container_id):
        """
        Returns the image id of a given container id, shortened to 12
        characters.
        """

        image_id = self._exec_docker(
            ['inspect', '-f', '{{.Image}}', container_id]
        )

        return image_id[0:12]

    def _exec_docker(self, args, docker='docker'):
        """
        Execute a docker command with the arguments provided as a list,
        returning the output if the command succeeds.
        """

        cmd = [self._docker(docker)] + args
        rc, out, err = self._run(cmd)

        if rc is not None and rc != 0:
            self._fail(err, rc)

        if out.strip().startswith('Usage:'):
            self._fail(
                ('Got usage output for cmd=%r:\n' % (cmd,)) + out + err, rc
            )

        return out

    def _run(self, cmd):
        return self.module.run_command(cmd)

    def _docker(self, docker):
        return self.module.get_bin_path(docker, True)

    def _fail(self, err, rc):
        self.module.fail_json(
            repo=self.repo, tag=self.tag, msg=err, rc=rc
        )


def _md5sum(string):
    return md5(string).hexdigest()


def main(module_class=None):
    if module_class is None:
        module_class = AnsibleModule

    module = module_class(
        argument_spec=dict(
            state=dict(default='present', choices=['present']),
            repo=dict(required=True),
            tag=dict(default='', required=False),
            keep_images=dict(default='-1', required=False),
        ),
        supports_check_mode=True
    )

    puller = DockerPuller(module)

    rc = None
    out = ''
    err = ''
    result = {}

    if module.check_mode:
        module.exit_json(changed=False)

    if module.params['keep_images'] != '-1':
        puller.remove_old_images()
    (rc, out, err), changed = puller.pull_repo()

    if rc is None:
        result['changed'] = False
    else:
        result['changed'] = changed

    if out:
        result['stdout'] = out
    if err:
        result['stderr'] = err

    module.exit_json(**result)


from ansible.module_utils.basic import *

if __name__ == '__main__':
    main()
