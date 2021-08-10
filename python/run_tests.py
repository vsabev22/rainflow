from pyrfc.test import test
from unittest.case import TestCase
import unittest
from io import StringIO
from pprint import pprint

stream = StringIO()
runner = unittest.TextTestRunner(stream=stream)
result = runner.run(unittest.makeSuite(test.TestRainflowCounting))
print( 'Tests run ', result.testsRun )
print( 'Errors ', result.errors )
pprint(result.failures)
stream.seek(0)
print( 'Test output\n', stream.read() )