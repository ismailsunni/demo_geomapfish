# -*- coding: utf-8 -*-

import logging
import re

from paste.deploy.converters import asbool
from pyramid.security import ALL_PERMISSIONS, Allow

LOG = logging.getLogger(__name__)

class Root:
    __acl__ = [(Allow, "role_admin", ALL_PERMISSIONS)]

    def __init__(self, request):
        self.request = request


class C2cPrefixMiddleware:
    """
    Translate a given prefix into a SCRIPT_NAME for the filtered application.
    PrefixMiddleware provides a way to manually override the root prefix
    (SCRIPT_NAME) of your application for certain, rare situations.
    When running an application under a prefix (such as '/james') in
    FastCGI/apache, the SCRIPT_NAME environment variable is automatically
    set to to the appropriate value: '/james'. Pylons' URL generating
    functions, such as url_for, always take the SCRIPT_NAME value into account.
    One situation where PrefixMiddleware is required is when an application
    is accessed via a reverse proxy with a prefix. The application is accessed
    through the reverse proxy via the the URL prefix '/james', whereas the
    reverse proxy forwards those requests to the application at the prefix '/'.
    The reverse proxy, being an entirely separate web server, has no way of
    specifying the SCRIPT_NAME variable; it must be manually set by a
    PrefixMiddleware instance. Without setting SCRIPT_NAME, url_for will
    generate URLs such as: '/purchase_orders/1', when it should be
    generating: '/james/purchase_orders/1'.
    To filter your application through a PrefixMiddleware instance, add the
    following to the '[app:main]' section of your .ini file:
    .. code-block:: ini
        filter-with = proxy-prefix
        [filter:proxy-prefix]
        use = egg:PasteDeploy#prefix
        prefix = /james
    The name ``proxy-prefix`` simply acts as an identifier of the filter
    section; feel free to rename it.
    Also, unless disabled, the ``X-Forwarded-Server`` header will be
    translated to the ``Host`` header, for cases when that header is
    lost in the proxying.  Also ``X-Forwarded-Host``,
    ``X-Forwarded-Scheme``, and ``X-Forwarded-Proto`` are translated.
    If ``force_port`` is set, SERVER_PORT and HTTP_HOST will be
    rewritten with the given port.  You can use a number, string (like
    '80') or the empty string (whatever is the default port for the
    scheme).  This is useful in situations where there is port
    forwarding going on, and the server believes itself to be on a
    different port than what the outside world sees.
    You can also use ``scheme`` to explicitly set the scheme (like
    ``scheme = https``).
    """
    def __init__(self, app, prefix='/',
                 translate_forwarded_server=True):
        self.app = app
        prefix = r'/tt[^/]+/'
        self.prefix = prefix.rstrip('/')
        self.translate_forwarded_server = translate_forwarded_server
        self.regprefix = re.compile("^(%s)(.*)$" % self.prefix)

    def __call__(self, environ, start_response):
        url = environ['PATH_INFO']
        LOG.error(url)
        match = self.regprefix.match(url)
        url = self.regprefix.sub(r'\2', url)
        if not url:
            url = '/'
        environ['PATH_INFO'] = url
        environ['SCRIPT_NAME'] = match.group(1) if match else self.prefix
        LOG.error(match)
        LOG.error(environ['SCRIPT_NAME'])
        LOG.error(url)
        LOG.error(environ)
        if self.translate_forwarded_server:
            if 'HTTP_X_FORWARDED_SERVER' in environ:
                environ['SERVER_NAME'] = environ['HTTP_HOST'] = environ.pop('HTTP_X_FORWARDED_SERVER').split(',')[0]
            if 'HTTP_X_FORWARDED_HOST' in environ:
                environ['HTTP_HOST'] = environ.pop('HTTP_X_FORWARDED_HOST').split(',')[0]
            if 'HTTP_X_FORWARDED_FOR' in environ:
                environ['REMOTE_ADDR'] = environ.pop('HTTP_X_FORWARDED_FOR').split(',')[0]
            if 'HTTP_X_FORWARDED_SCHEME' in environ:
                environ['wsgi.url_scheme'] = environ.pop('HTTP_X_FORWARDED_SCHEME')
            elif 'HTTP_X_FORWARDED_PROTO' in environ:
                environ['wsgi.url_scheme'] = environ.pop('HTTP_X_FORWARDED_PROTO')
        LOG.error(dir(self.app))
        return self.app(environ, start_response)


def make_prefix_middleware(
    app, global_conf, myprefix='/',
    translate_forwarded_server=True):
    del global_conf

    return C2cPrefixMiddleware(
        app, prefix=myprefix,
        translate_forwarded_server=asbool(translate_forwarded_server))
