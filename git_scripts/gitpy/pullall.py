#!/usr/bin/env python
import os
import sys
from optparse import OptionParser

if __name__ == '__main__':
    parser = OptionParser()

    parser.add_option('-f', '--file', help='Help!', action='store', type='string', dest='Destination')
    (options, args) = parser.parse_args()

    print 'Total Args: ' + str(len(sys.argv))
    print 'List Args: ' + str(sys.argv)
    print options, args

    print 'Test!'
