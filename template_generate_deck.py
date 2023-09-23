import shutil
import datetime
import os
import tempfile
import textwrap
import warnings
import itertools
import time
import sys
sys.path.insert(1, 'External/genanki')
import genanki

def test_media_files_in_subdirs():
  deck_id = 1694391122062

  # change to a scratch directory so we can write files
  cwd = os.getcwd()
  os.chdir(tempfile.mkdtemp())
  
  deck = genanki.Deck(deck_id, 'Default (G) Tuning Banjo Chords')
  model = genanki.Model(deck_id, 'Simple Banjo Model',
                        fields=[{ 'name':'Question' },
                                { 'name':'Answer' }],
                        templates=[{'name': 'Card 1',
                                    'qfmt': '{{Question}}',
                                    'afmt': '<img src="{{Answer}}">'}])
  note = genanki.Note(model, [ 'A', 'A.png'])
  deck.add_note(note)
  
  shutil.copy(cwd+'/Docs/A.png', ".")
  
  # populate files with data
  package = genanki.Package(deck, media_files=['A.png'])
  package.write_to_file(cwd+'/banjo_chords.apkg')

if __name__ == '__main__':
  test_media_files_in_subdirs()
