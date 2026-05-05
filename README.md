# BlackFox Custom AHK Browser (WebView2)

Un navegador web minimalista y ultra ligero construido con **AutoHotkey v2** utilizando el motor **Microsoft Edge WebView2**. Diseñado para ser funcional, sin bordes y totalmente personalizable.

## ✨ Características

- **Diseño Minimalista**: Interfaz sin bordes (frameless) con esquinas cuadradas estilo moderno.
- **Barra de Direcciones Inteligente**:
  - `Enter`: Navegar a la URL.
  - `Ctrl + Enter`: Autocompletar con `.com`.
  - `Alt + Enter`: Autocompletar con `.net`.
- **Modo Enfoque**: Opción para ocultar la barra de direcciones y centrarse solo en el contenido web.
- **Controles de Ventana Personalizados**: Iconos modernos (Segoe Fluent Icons) para Maximizar, Restaurar y Cerrar.
- **Always on Top**: Mantén el navegador siempre visible sobre otras ventanas.
- **Portátil**: Gestión robusta de dependencias para funcionar como ejecutable (.exe).

## 🚀 Instalación y Uso

### Requisitos previos
1. Tener instalado [AutoHotkey v2](https://www.autohotkey.com/).
2. [WebView2 Runtime](https://developer.microsoft.com/en-us/microsoft-edge/webview2/) (generalmente ya incluido en Windows 10 y 11).

### Ejecución desde el código
1. Clona este repositorio o descarga los archivos.
2. Asegúrate de que la carpeta `Lib` contenga la librería `WebViewToo.ahk` y las DLLs correspondientes.
3. Ejecuta `Navegador.ahk`.

### Compilación (Crear el .exe)
Si deseas convertirlo en un ejecutable estable:
1. Usa **Ahk2Exe**.
2. Una vez creado el `.exe`, **copia el archivo `WebView2Loader.dll`** (de la carpeta 64bit o 32bit según tu sistema) y pégalo justo al lado del ejecutable. Esto evita errores de carga de recursos.

## ⌨️ Atajos de Teclado
| Combinación | Acción |
| :--- | :--- |
| `Enter` | Ir a la URL escrita |
| `Ctrl + Enter` | Añadir ".com" e ir |    
| `Alt + Enter` | Añadir ".net" e ir |

## 🛠️ Tecnologías utilizadas
- [AutoHotkey v2](https://www.autohotkey.com/)
- [WebViewToo Library](https://github.com/TheDewd/WebViewToo) (por TheDewd)
- Microsoft Edge WebView2 engine
