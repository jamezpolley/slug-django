.PHONY: sample_app .hgignore .gitignore clean serve symlinks

serve: git openid symlinks clean
	./manage.py runserver

###############################################################################
# git submodules
###############################################################################

git:
	@echo "Updating git submodules." ;\
		git submodule init; \
		git submodule update

openid: git
	-ln -s python-openid/openid openid

###############################################################################
# Markdown parser
###############################################################################
MARKDOWN=Markdown-2.0.3
MARKDOWN_EXT=$(shell find markdown-extensions -type f -name \*.py)

# Download the tar.gz
$(MARKDOWN).tar.gz:
	curl -O http://pypi.python.org/packages/source/M/Markdown/$(MARKDOWN).tar.gz

# Extract the tar.gz
$(MARKDOWN): $(MARKDOWN).tar.gz $(MARKDOWN_EXT)
	tar -zxvf $(MARKDOWN).tar.gz
	@# Update modtime on tar.gz to match directory so we don't continually rebuild
	@touch -r $@ -m $^
	for f in $(MARKDOWN_EXT); do \
		cp $$f $(MARKDOWN)/markdown/extensions/; \
	done
	ln -sf markdown $^

# Human name target
markdown: $(MARKDOWN)

markdown-clean:
	rm -rf $(MARKDOWN)*

###############################################################################
# django-nonrel, djangoappengine, and friends
###############################################################################

upstream:
	mkdir upstream

upstream/django-nonrel upstream/djangoappengine upstream/djangotoolbox upstream/django-dbindexer upstream/django-testapp upstream/django-mediagenerator: BBUSER = wkornewald
upstream/django-autoload: BBUSER=twanschik
upstream/django-nonrel upstream/djangoappengine upstream/djangotoolbox upstream/django-dbindexer upstream/django-testapp upstream/django-mediagenerator upstream/django-autoload: upstream
	@if test -d $@; \
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

###############################################################################
# django-openid-auth
###############################################################################

OAVERSION=0.3
OPENIDAUTH=django-openid-auth-$(OAVERSION)

$(OPENIDAUTH).tar.gz:
	curl -LO http://launchpad.net/django-openid-auth/trunk/$(OAVERSION)/+download/$(OPENIDAUTH).tar.gz

$(OPENIDAUTH): $(OPENIDAUTH).tar.gz
	tar -zxvf $^
	touch -r $@ -m $^

django_openid_auth: $(OPENIDAUTH)
	ln -s $^/$@ $@

###############################################################################

symlinks: django djangotoolbox autoload dbindexer djangoappengine mediagenerator django_openid_auth openid

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

