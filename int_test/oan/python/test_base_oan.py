"""
    This module contains base classes and other
    common tools for testing
"""

import unittest
import logging
import glob
import os
import json


TEST_ENV = {}


class TestConfigurationError(Exception):
    pass


class BaseTestCase(unittest.TestCase):
    logger = logging.getLogger('BaseTestCase')

    def get_test_data_dir(self):
        try:
            return TEST_ENV["TEST_DATA"]
        except KeyError:
            raise TestConfigurationError("Please set 'TEST_DATA' in TEST_ENV")

    def get_test_env(self, key):
        try:
            return TEST_ENV[key]
        except KeyError:
            raise TestConfigurationError(
                "Please set '{0}' in TEST_ENV".format(key)
            )

    def set_env_from_test(self, var):
        if os.getenv(var) is None:
            os.environ[var] = self.get_test_env(var)
            # self.logger.debug('set_env_from_test: {0} = {1}'.format(var, os.getenv(var)))
        else:
            pass
            # self.logger.debug('set_env_from_test: {0} already set to {1}'.format(var, os.getenv(var)))

    def set_env_from_test_env(self):
        for key in TEST_ENV.keys():
            self.set_env_from_test(key)

    def _load_json(self, file_name):
        with open(file_name) as f:
            return f.read()

    def _load_jo(self, file_name):
        return json.loads(self._load_json(file_name))

    def load_file_pattern_as_jo(self, pattern):
        res = []
        for fn in sorted(glob.glob(pattern)):
            res.append(self._load_jo(fn))
        return res

    def set_local_dir_for(self, test_num):
        os.environ['LOCAL_DIR'] = '{0}/{1}'.format(self.get_test_data_dir(), test_num)

    def load_output_ref_as_jo(self, pattern):
        full_pattern = '{0}/ref/{1}'.format(os.getenv('LOCAL_DIR'), pattern)
        return self.load_file_pattern_as_jo(full_pattern)

    def _load_json_by_name(self, name):
        json_file = "{0}/{1}.json".format(os.getenv('LOCAL_DIR'), name)
        return self._load_json(json_file)
