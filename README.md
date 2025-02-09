# Proyecto Final Laboratorio de Computación IV - UTN
## Integración de API con Node.js + App Flutter

### Descripción del Proyecto:
Este proyecto es una extensión del Trabajo Práctico 2, en el cual originalmente se utilizaban mocks para gestionar toda la información de las películas. En esta proyecto, se modifico la aplicación para consumir datos reales desde la API de The Movie Database (TMDB), reemplazando los mocks por información en tiempo real obtenida mediante una API en Node.js.

### API en Node.js
Para integrar correctamente la API con la app, se realizaron algunas modificaciones:
- Se implemento recibir y manejar géneros de las películas, lo cual antes no estaba.
- Se agregaron las imágenes de portada para que las películas muestren sus posters.

https://github.com/luchobalot/API-Movies-Nodejs-Final-Laboratorio-IV

Inicialmente, intente consumir la API desde un entorno localhost, pero al probar la aplicación en un celular físico, surgieron problemas de conectividad, ya que un servidor local no es accesible directamente desde otro dispositivo en la misma red. Para solucionar este problema, opte por desplegar una nueva API en Render (la misma que hice en TP1, pero modifcando lo anteriormente explicado), permitiendo el acceso desde cualquier dispositivo.

Importante: Al abrir la pantalla donde se muestran las películas es probable que tarden unos segundos en cargar cuando se ejecuta por primera vez la app.

### HomeSreen (Pantalla Principal)
Es la pantalla principal de la aplicación Flutter que muestra información básica, tanto del perfil del usuario como un carrusel de imágenes de películas que se van cambiando cada 5seg.

### Pantallas de Películas
Estas Pantallas muestran una lista de las películas más relevantes de 2025, junto con su título, una breve descripción y su imagen de portada. Esta información se obtiene de manera dinámica a través de la API.
Al hacer clic sobre una película, se abre una pantalla de detalles donde se muestra:
- El póster en detalle (con opción de hacer zoom).
- La descripción completa de la película.
- El puntaje de la película.
- Los géneros asociados a la película.

Sistema de Favoritos: En esta pantalla también es posible marcar una película como favorita, lo que permitirá al usuario verla más tarde en la pantalla de Películas Favoritas. La funcionalidad de marcar y desmarcar favoritos se gestiona a través de un FavoriteProvider.

### Conclusión del proyecto final
En este proyecto, realice lo siguiente:
- Integración de una API externa (TMDB) con la aplicación Flutter a través de un servidor intermedio en Node.js.
- Crear una aplicación con Flutter que simule una página web de películas, donde los usuarios puedan gestionar las películas favoritas de manera interactiva.
