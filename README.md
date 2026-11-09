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

