from django.conf.urls.defaults import *

from django.contrib import admin
admin.autodiscover()

handler500 = 'djangotoolbox.errorviews.server_error'

urlpatterns = patterns('',
    ('^_ah/warmup$', 'djangoappengine.views.warmup'),
    (r'^openid/', include('django_openid_auth.urls')),
    (r'^admin/', include(admin.site.urls)),
    ('^$', 'django.views.generic.simple.direct_to_template',
     {'template': 'home.html'}),
)
