instalar_nginx:
  pkg.installed:
    - name: nginx

pagina_personalizada:
  file.managed:
    - name: /var/www/html/index.html
    - source: salt://files/index.html
    - user: www-data
    - mode: '0644'

servicio_nginx:
  service.running:
    - name: nginx
    - require:
      - pkg: instalar_nginx
    - watch:
      - file: pagina_personalizada
