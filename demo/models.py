# -*- coding: utf-8 -*-

import logging

from sqlalchemy import Column, types
from pyramid.i18n import TranslationStringFactory

from c2cgeoportal.models import *
#from c2cgeoportal.models import _schema

_ = TranslationStringFactory('demo')
log = logging.getLogger(__name__)
