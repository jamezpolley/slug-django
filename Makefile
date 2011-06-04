upstream:
	mkdir upstream

upstream/django-nonrel upstream/djangoappengine upstream/djangotoolbox upstream/django-dbindexer upstream/django-testapp upstream/django-mediagenerator: BBUSER = wkornewald
django-autoload: BBUSER=twanschik
upstream/django-nonrel upstream/djangoappengine upstream/djangotoolbox upstream/django-dbindexer upstream/django-testapp upstream/django-mediagenerator upstream/django-autoload: upstream
	if test -d $@; \
		then cd $@; hg pull; \
		else cd upstream; hg clone https://bitbucket.org/$(BBUSER)/$(notdir $@); \
	fi

upstream/django-nonrel/django: upstream/django-nonrel
django: upstream/django-nonrel/django
	ln -s $^ $@

upstream/djangotoolbox/djangotoolbox: upstream/djangotoolbox
djangotoolbox: upstream/djangotoolbox/djangotoolbox
	ln -s $^ $@

upstream/django-autoload/autoload: upstream/django-autoload
autoload: upstream/django-autoload/autoload
	ln -s $^ $@

upstream/django-dbindexer/dbindexer: upstream/django-dbindexer
dbindexer: upstream/django-dbindexer/dbindexer
	ln -s $^ $@

djangoappengine: upstream/djangoappengine
	ln -s $^ $@

upstream/django-mediagenerator/mediagenerator: upstream/django-mediagenerator
mediagenerator: upstream/django-mediagenerator/mediagenerator
	ln -s $^ $@

.PHONY: sample_app .hgignore clean serve symlinks

symlinks: django djangotoolbox autoload dbindexer djangoappengine mediagenerator

sample_app: upstream/django-testapp
	cp -r $^/* .

.gitignore:
	-rm .gitignore
	find . -type l -d 1 | cut -c 3- >> .gitignore
	find upstream -type d -d 1 >> .gitignore

.hgignore:
	-rm .hgignore
	find . -type l -d 1 | cut -c 3- >> .hgignore
	find upstream -type d -d 1 >> .hgignore

clean:
	find . -name \*.pyc -exec rm \{\} \;

serve:
	./manage.py runserver
