#!/usr/bin/env python3

from pathlib import Path
import shlex
import subprocess
import tempfile
import unittest

class Simple(unittest.TestCase):

    def setUp(self):
        self.tempdir = tempfile.TemporaryDirectory()
        self.temppath = Path(self.tempdir.name)
        self.run_hg('init')

    def tearDown(self):
        self.tempdir.cleanup()

    def run_hg(self, command):
        subprocess.run(['hg'] + shlex.split(command), cwd=self.tempdir.name, check=True)

    def run_cin(self, command):
        cmd = shlex.split(f"bash -c 'source /home/maik/projects/cinnabar/cinnabar.sh && COLOR=0 {command}'")
        p=subprocess.run(cmd, cwd=self.tempdir.name, stdout=subprocess.PIPE)
        output = p.stdout.decode().strip()
        self.assertEqual(p.returncode, 0, output)
        return output

    def test_empty_repo_should_have_no_status(self):
        output = self.run_cin('do_status')
        self.assertEqual(output, '')

    def test_repo_with_one_file_should_show_file_as_untracked(self):
        (self.temppath / 'f0').touch()
        output = self.run_cin('do_status')
        self.assertEqual(output, '? [1] f0')

    def test_repo_with_added_file(self):
        (self.temppath / 'f0').touch()
        self.run_hg('add f0')
        output = self.run_cin('do_status')
        self.assertEqual(output, 'A [1] f0')
