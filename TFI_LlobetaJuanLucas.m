function MuestreoNyquist
    % Crear la interfaz gráfica
    figura = uifigure('Name', 'Gráfico de Señal', 'Position', [100, 100, 650, 300]);

    % Agregar un título
    titulo = uilabel(figura, 'Text', 'Muestreo de Señales', 'FontWeight', 'bold', 'FontSize', 16, 'Position', [250, 250, 200, 30]);
    
    % Agregar un logo C:\Users\juanl\Desktop\MatLab Project\logo.png
    logo = imread('C:\Users\juanl\Desktop\TFI COMUNICACIONES\logo.png'); % Cambia 'ruta_del_archivo/logo.png' por la ruta de tu imagen
    ax = uiaxes(figura, 'Units', 'pixels', 'Position', [385, 215, 150, 100]);
    imshow(logo, 'Parent', ax);

    % Crear controles de entrada y etiquetas con unidades
    etiquetaAmplitud = uilabel(figura, 'Text', 'Amplitud:', 'Position', [50, 200, 80, 22]);
    entradaAmplitud = uieditfield(figura, 'numeric', 'Position', [150, 200, 100, 22]);

    etiquetaFrecuencia = uilabel(figura, 'Text', 'Frecuencia:', 'Position', [50, 170, 80, 22]);
    entradaFrecuencia = uieditfield(figura, 'numeric', 'Position', [150, 170, 100, 22]);
    unidadFrecuencia = uilabel(figura, 'Text', 'Hz', 'Position', [260, 170, 50, 22]);

    % Crear lista desplegable para seleccionar la función
    opcionesFuncion = {'sin', 'cos'};
    etiquetaFuncion = uilabel(figura, 'Text', 'Función:', 'Position', [50, 140, 80, 22]);
    listaFuncion = uidropdown(figura, 'Items', opcionesFuncion, 'Position', [150, 140, 100, 22], 'ValueChangedFcn', @(dropdown,event)actualizarFuncion());

    % Control deslizante para ajustar la frecuencia de Nyquist
    etiquetaFs = uilabel(figura, 'Text', 'Frecuencia de Nyquist:', 'Position', [300, 200, 150, 22]);
    sliderFs = uislider(figura, 'Limits', [1, 10], 'Value', 2, 'Position', [460, 200, 100, 3], 'ValueChangedFcn', @(slider,event)actualizarFs());

    % Botón para restablecer el valor del slider
    botonRestablecer = uibutton(figura, 'Text', 'Restablecer', 'Position', [455, 130, 80, 30], 'ButtonPushedFcn', @(btn,event)restablecerSlider());

    % Botón para graficar
    botonGraficar = uibutton(figura, 'Text', 'Graficar', 'Position', [150, 100, 100, 30], 'ButtonPushedFcn', @(btn,event)graficarFcn());

    % Botón de alternancia entre 'plot' y 'stem'
    botonAlternar = uibutton(figura, 'Text', 'Interpolar', 'Position', [455, 90, 80, 30], 'ButtonPushedFcn', @(btn,event)alternarGraficoFcn());

    % Agregar pie de página con la fecha y el autor
    fechaActual = datestr(now, 'dd/mm/yyyy');
    autor = 'Juan Lucas Llobeta'; % Reemplaza con el nombre del autor
    piePagina = uilabel(figura, 'Text', sprintf('Fecha: %s   |   Autor: %s', fechaActual, autor), 'Position', [50, 10, 550, 15]);

    % Valor original del slider
    valorOriginalSlider = 2;

    % Inicializar la opción de graficar como 'stem'
    graficoActual = 'stem';

    % Función para restablecer el valor del slider
    function restablecerSlider()
        sliderFs.Value = valorOriginalSlider;
        actualizarFs();
    end

    % Función para alternar entre 'plot' y 'stem'
    function alternarGraficoFcn()
        if strcmp(graficoActual, 'stem')
            graficoActual = 'plot';
        else
            graficoActual = 'stem';
        end

        % Actualizar la interfaz gráfica después de cambiar el tipo de gráfico
        graficarFcn();
    end

    % Función para actualizar la función seleccionada
    function actualizarFuncion()
        % Actualizar la función seleccionada
        graficarFcn();
    end

    % Función para actualizar la frecuencia de Nyquist
    function actualizarFs()
        % Actualizar la interfaz gráfica mientras desplazas el slider
        graficarFcn();
    end

    % Función para graficar
    function graficarFcn()
        % Obtener datos de entrada
        amplitud = entradaAmplitud.Value;
        frecuencia = entradaFrecuencia.Value;
        seleccionFuncion = listaFuncion.Value;  % Obtener la función seleccionada

        % Crear la señal
        tiempo = 0:0.01:1; % ajusta según tu necesidad
        if strcmp(seleccionFuncion, 'sin')
            signal = amplitud * sin(2 * pi * frecuencia * tiempo);
        else
            signal = amplitud * cos(2 * pi * frecuencia * tiempo);
        end

        % Graficar según la opción actual
        subplot(2, 1, 1), plot(tiempo, signal, 'b', 'LineWidth', 2);
        grid on;
        title('Señal en el tiempo');
        xlabel('Tiempo');
        ylabel('Amplitud');

        % Crear la segunda señal
        fs = sliderFs.Value * frecuencia; % frecuencia de Nyquist
        n = fs;
        Ts = (0:n) ./ fs;
        
        % Actualizar la función xn según la opción seleccionada
        if strcmp(seleccionFuncion, 'sin')
            xn = amplitud * sin(2 * pi * frecuencia * Ts);
        else
            xn = amplitud * cos(2 * pi * frecuencia * Ts);
        end

        % Graficar según la opción actual en la segunda gráfica
        subplot(2, 1, 2);
        if strcmp(graficoActual, 'stem')
            stem(Ts, xn, 'r', 'LineWidth', 2);
        else
            plot(Ts, xn, 'r--o','LineWidth', 1);
        end
        grid on;
        title('Señal muestreada');
        xlabel('Tiempo');
        ylabel('Amplitud');
    end
end
