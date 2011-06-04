#!/usr/bin/python
#
# -*- coding: utf-8 -*-
# vim: set ts=4 sw=4 et sts=4 ai:

from django.contrib import admin

import signup.models

class EventAdmin(admin.ModelAdmin):
    exclude = ('created_by','plaintext','html', 'published', 'emailed')
    list_display = ('name', 'start', 'end')

    def save_model(self, request, obj, form, change):
        if not change:
            obj.created_by = request.user
        obj.save()

admin.site.register(signup.models.Event, EventAdmin)
