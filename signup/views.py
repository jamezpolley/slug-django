# Create your views here.

import signup.models

from django.contrib.auth.decorators import login_required
from django.http import HttpResponseRedirect
from django.http import Http404
from django.views.generic.simple import direct_to_template


@login_required
def editevent(request, eventid):
    if not request.user.is_staff:
        #Is logged in, but not staff. Shennanigans! Send them home
        return HttpResponseRedirect('/')
    templates = signup.models.Templates.objects.all()
    try:
        event = signup.models.Event.objects.get(pk=eventid)
    except Event.DoesNotExist:
        raise Http404

    return render_to_response('signup/editevent.html', {
        'event': event, })
