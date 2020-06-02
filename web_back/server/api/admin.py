from django.contrib import admin

from .models import User, Photo, Comment


@admin.register(User)
class TrackAdmin(admin.ModelAdmin):
    list_display = ('name', 'surname', 'email')


@admin.register(Photo)
class TrackAdmin(admin.ModelAdmin):
    list_display = ('title', 'photo_path')


@admin.register(Comment)
class TrackAdmin(admin.ModelAdmin):
    list_display = ('author', 'photo', 'text')
