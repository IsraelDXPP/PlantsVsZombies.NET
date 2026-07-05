# PlantsVsZombies.net

[English Version](./README.en.md) | [中文版本](./README.md)

[Wiki(Chino)](https://github.com/Mewnojs/PlantsVsZombies.NET/wiki)

#### Descripción
Un proyecto open-source multiplataforma de Plants Vs. Zombies, escrito en C#, originado del código de la edición de Windows Phone.

#### Estructura del Proyecto
Todo el proyecto se compone de tres partes: *Lawn*, *Sexy* y *Sexy.TodLib*.
**Lawn** contiene la mecánica principal del sistema del juego, incluyendo la selección y generación de zombies, la colocación de plantas, etc.
**Sexy** funciona como capa intermedia entre el juego y el framework XNA, proporcionando varios gestores que ayudan a controlar los recursos multimedia y widgets básicos de UI.
**Sexy.TodLib** controla el renderizado de efectos gráficos.
**LawnModExtension** es un nuevo módulo que proporciona soporte de modding para el juego usando IronPython3.

#### Instalación

1.  Clona el repositorio, usa VS2026 con .NET SDK 10 para abrir el archivo slnx;
2.	Extrae el contenido del juego (no incluido en este repo, ver [contactos](####Contactos)) en el directorio de contenido;
	- Para la versión PCDX/PCGL: extraer en `Lawn_PCGL/Content` o `Lawn_PCDX/Content`
	- Para la versión Android: extraer en `Lawn_Android/Assets/Content`
3.  (Opcional) Descarga el paquete de contenido chino y sobrescribe el directorio de contenido para obtener soporte en chino;
4.	Elige un proyecto de inicio (la versión que hayas elegido) y compila el programa principal;
5.	¡A disfrutar!

#### Aviso

1.  Esta es una versión temprana e inestable del proyecto, pueden haber fallos. Si los hay, por favor repórtalos como issues, es muy importante para mí. ¡Gracias a todos los que contribuyen código y reportan bugs!
2.	Los archivos de guardado están en `.\docs\userdata` (esto cambió desde v0.13.1)

#### Modding

Hay dos formas de modificar el juego, cada una con sus pros y contras:
1. Haz fork de este repo y modifica el código fuente o los recursos directamente, luego publica tu propia versión;
2. Crea scripts de IronPython3 para modificar el juego. Este método no requiere modificar el código fuente y es compatible con diferentes versiones de PvZ (derivadas de este proyecto), pero el contenido que puedes modificar es limitado y necesitas tener cierto conocimiento de técnicas de Hooking.
(El soporte de Android para scripts de IronPython3 no está disponible por ahora)
Para el segundo método, puedes consultar los ejemplos en el documento de la API de LawnMod en la Wiki. Los archivos de script se colocan en `.\mods\`, y el juego los cargará automáticamente al iniciar.

#### Contactos

- Adaptado por: MnJS (alias 2508)
- Grupo QQ: 884792079
- Discord Link: [discord.gg/uXz6g6Adnm](https://discord.gg/uXz6g6Adnm) 
