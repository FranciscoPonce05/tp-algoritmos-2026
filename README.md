# tp-algoritmos-2026
<br>
<br>

### Paso 1: Clonar el proyecto por primera vez en cada PC

Cada integrante del grupo hace lo siguiente en su computadora:

1. Abre GitHub Desktop.
2. Va a **File > Clone repository**.
3. Selecciona su repositorio (`tp-algoritmos-2026`) y elige una carpeta en su disco (por ejemplo, dentro de `C:\LazarusProjects\`).

### Paso 2: El ciclo de trabajo de todos los días

Imaginemos que a vos te toca programar la **Unit de Clientes** y a tu compañero los **Árboles**:

1. **Antes de tocar nada en Lazarus:** Abrís GitHub Desktop y hacés clic en **Fetch origin** y luego **Pull origin**. Esto descarga a tu PC lo último que haya subido tu compañero.
2. **Programás en Lazarus:** Abrís tu proyecto, trabajás en tu Unit, probás que compile y funcione bien.
3. **Guardás en Lazarus** (Ctrl + S).
4. **Subís los cambios a GitHub:**
* Volvés a GitHub Desktop.
* A la izquierda vas a ver una lista con los archivos que modificaste en verde.
* Abajo a la izquierda escribís un breve resumen de lo que hiciste en el cuadro de texto (Ej: *"Agregué validación de DNI en archivo_clientes.pas"*).
* Hacés clic en **Commit to main**.
* Hacés clic arriba en **Push origin** (esto sube tus cambios a la nube para que tus compañeros los vean).



---

## Consejos clave para sobrevivir al TP en grupo

 **nunca dos personas editen el mismo archivo `.pas` al mismo tiempo**. Que uno se encargue de `archivo_clientes.pas` y otro de `arbol.pas`. Así se evitan los temidos *"Conflicts"* (conflictos de código que Git no sabe cómo unir automáticamente).


* **Compilen antes de hacer commit:** Asegúrense de que Lazarus compile bien antes de subir el código a GitHub. Subir código roto interrumpe al resto del equipo.


# Guía de Uso de Ramas (Branches) con GitHub Desktop y Web

En nuestro proyecto de Algoritmos y Estructuras de Datos, las **ramas (branches)** nos permiten trabajar en paralelo (por ejemplo, mientras uno diseña el archivo de clientes, otro programa los árboles) sin romper el código principal que funciona.

Como trabajamos con **GitHub Desktop** y la interfaz web, el manejo de ramas es visual y muy sencillo. Aquí te mostramos cómo utilizarlas en el día a día.

---

## 1. Visualizar en qué rama estamos

* **En GitHub Desktop:** Mirá siempre la parte superior central de la aplicación. Verás un rectángulo con un ícono de rama y el nombre actual (por lo general, **`main`**).
* **En la Web de GitHub:** En la esquina superior izquierda del repositorio, hacé clic en el menú desplegable que dice **`main`** para ver todas las ramas existentes.

---

## 2. Crear una nueva rama para desarrollar una funcionalidad

Antes de escribir código nuevo para tu parte del TP (como una Unit o el menú), creá una rama dedicada:

### Usando GitHub Desktop:
1. Hacé clic en el botón de la rama actual (arriba al centro).
2. Hacé clic en **New Branch** (Nueva rama).
3. Ponéle un nombre descriptivo (ej: `feature-clientes`, `rama-arboles`, `modulo-estadisticas`).
4. Hacé clic en **Create branch**.
5. Hacé clic en **Publish branch** (si es la primera vez que la subís) para que tus compañeros puedan verla.

### Usando la Web de GitHub:
1. Hacé clic en el menú desplegable de ramas (donde dice `main`).
2. Escribí el nombre de tu nueva rama en el buscador.
3. Hacé clic en la opción que dice **Create branch: [nombre] from 'main'**.

---

## 3. Subir tus cambios (Commit y Push)

Mientras programás en Lazarus en tu rama:
1. Abrí **GitHub Desktop**. Verás tus archivos modificados en la pestaña **Changes**.
2. Abajo a la izquierda, escribí un mensaje claro de lo que hiciste (Ej: *"Agregué la carga de clientes en el archivo"*).
3. Hacé clic en **Commit to [nombre-de-tu-rama]**.
4. Hacé clic en **Push origin** para enviar los cambios a la nube.

---

## 4. Integrar tu trabajo al proyecto principal (Merge / Pull Request)

Una vez que tu parte está terminada, probada y compila perfectamente en Lazarus, es hora de juntarla con la rama oficial (`main`):

### Usando GitHub Desktop:
1. Arriba, asegurate de estar parado en la rama `main` (hacé clic en la rama actual y cambiate a `main`).
2. Hacé clic en **Branch** en el menú superior y seleccioná **Merge into current branch...** (Combinar en la rama actual).
3. Elegí la rama que querés integrar (ej: `feature-clientes`) y hacé clic en **Create Merge**.
4. Por último, hacé un **Push origin** para actualizar el `main` en la nube.

### Usando la Web de GitHub (Método recomendado para equipos):
1. Entrá al repositorio en la web de GitHub.
2. Te aparecerá un aviso amarillo invitándote a crear un **Pull Request** para la rama que acabas de subir. Hacé clic en **Compare & pull request**.
3. Revisá los cambios, agregá a tus compañeros como *Reviewers* si querés, y hacé clic en **Create pull request**.
4. Hacé clic en **Merge pull request** y luego en **Confirm merge**. ¡Listo! Los cambios ya forman parte de la versión final del TP.
