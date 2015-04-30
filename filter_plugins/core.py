from ansible import errors

# def with_apps(sites):
#     apps = []
#     for site in sites:
#         if 'apps' in site:
#             for app in site['apps']:
#                 apps.append(app)
#     return apps
#
# def slashes(p):
#     if len(p) == 0 or p[-1] != '/':
#         p = p + '/'
#     if p[0] != '/':
#         p = '/' + p
#     return p
#
class FilterModule(object):
    def filters(self):
        return {
            # 'with_apps': with_apps,
            # 'slashes': slashes
        }