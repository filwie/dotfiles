#!/usr/bin/env python3

import hashlib

git_log_cmd = 'git log --format=\'%H %at %ct\''

git_log_result = '''
b03107d7664e475b3aa972b7b3169eda7a9ebce7 1566848958 1566848958
0e3c1f3aafa40ed5fd5f8ae7fe772775f5e0a615 1566849644 1566849644
cf8fae74249dda0239fe59bc531c49ed5f32e943 1566849148 1566849148
b787fefdf601f5d0ef1514720203f159b0554159 1566848997 1566848997
c7b84469a2329d6962aad91d783ff0a5bba38f10 1562598095 1562598153
6cde641fd6e72b50bdfb21d25b410091ef5178ad 1562338124 1562338124
'''

commit_lines = git_log_result.strip().split('\n')


class Commit(object):
    def __init__(self, sha1, author_timestamp, commit_timestamp, **kwargs):
        for k, v in kwargs.items():
            setattr(self, k, v)
