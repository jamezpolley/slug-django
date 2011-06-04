#!/usr/bin/python
#
# -*- coding: utf-8 -*-
# vim: set ts=4 sw=4 et sts=4 ai:

"""Module contains the models of objects used in the application."""

from django.db import models
from django.contrib import admin
from django.contrib.auth.models import User

#class Announcement(db.Model):
#    """An announcement for an event."""
#    created_by = openid.UserProperty(
#            auto_current_user_add=True, required=True)
#    created_on = db.DateTimeProperty(
#            auto_now_add=True, required=True)
#
#    name = db.StringProperty(required=True)
#    plaintext = db.TextProperty()
#    html = db.BlobProperty()
#
#    published_by = appengine.UserProperty(
#            auto_current_user_add=True, required=True)
#    published_on = db.DateTimeProperty(
#            auto_now_add=True, required=True)


class Event(models.Model):
    """An event."""

    def get_url(self):
        """Return the canonical url for an event."""
        return "/event/%s" % self.key().id()

    created_by = models.ForeignKey(User)
    created_on = models.DateTimeField(
            auto_now_add=True)

    name = models.CharField(blank=False)
    input = models.TextField()
    plaintext = models.TextField()
    html = models.TextField()

    published = models.BooleanField(default=False)
    #announcement = models.ReferenceField(Announcement)

    emailed = models.BooleanField(default=False)

    start = models.DateTimeField(blank=False)
    end = models.DateTimeField(blank=False)

admin.site.register(Event)


#class LightningTalk(db.Model):
#    """An lightning talk to be given at an event."""
#    created_by = openid.UserProperty(
#            auto_current_user_add=True, required=True)
#    created_on = db.DateTimeProperty(
#            auto_now_add=True, required=True)
#
#    name = db.StringProperty(required=True)
#    text = db.StringProperty(multiline=True)
#
#    # If a approver exists, then it is approved.
#    approver = appengine.UserProperty()
#
#    given_at = db.Reference(Event)


#class Response(db.Model):
#    """An RSVP to attend an event."""
#    created_by = openid.UserProperty(
#            auto_current_user_add=True, required=True)
#    created_on = db.DateTimeProperty(
#            auto_now_add=True, required=True)
#
#    event = db.ReferenceProperty(Event, collection_name="responses")
#
#    attending = db.BooleanProperty(required=True, default=True)
#
#    # Should the response be hidden from everyone?
#    #hide = db.BoolenProperty(required=False, default=False)
#
#    # If this is a guest, then we store their details here, otherwise we just
#    # use the creater's details.
#    guest = db.BooleanProperty(required=True, default=False)
#    guest_name = db.StringProperty()
#    guest_email = db.EmailProperty()
