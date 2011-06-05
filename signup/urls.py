from django.conf.urls.defaults import *

urlpatterns = patterns('signup.views',
    url(r'^(?P<eventid>.*)/edit$', 'editevent'),
)
