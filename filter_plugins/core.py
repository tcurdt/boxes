from ansible import errors

def token(s, p, delim=':'):
    tokens = s.split(delim)
    return tokens[p]

def host(s):
    return token(s, 0)

def port(s):
    return token(s, 1)

class FilterModule(object):
    def filters(self):
        return {
            'host': host,
            'port': port
        }