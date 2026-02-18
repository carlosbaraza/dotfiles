#!/bin/bash
echo -e "1\nQ\n2\nW\n3\nE\n4\nR\n5\nT\n6\nY\n7\nU\n8\nI\n9\nO\nA\nB\nC\nD\nF\nG\nM\nN\nP\nS\nV\nX\nZ" \
  | /opt/homebrew/bin/aerospace workspace --wrap-around --stdin prev
