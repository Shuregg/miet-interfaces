# miet-interfaces-Lab-1_RLL(2, 7)
Код RLL
Другое название кода - RLL-код с ограничением длины поля записи (Run Length Limit - RLL). Это семейство методов кодирования.
Отличия внутри семейства определяются двумя параметрами: run length - минимальное количество битовых интервалов между сменами полярности напряжения, и run limit - максимальное количество битовых интервалов без смены полярности.
Рассмотрим популярный вариант RLL - RLL (2,7). Для него составляется словарь кодирования.

Примечание: R - смена полярности в начале полутакта; N - полярность не меняется.
![изображение](https://github.com/Shuregg/miet-interfaces/assets/47576452/76ba1211-7703-4a0c-88c4-f2a5ba878302)

Список констант и сигналов, которые могут быть использованы в написание кодера.

localparam max_bits_in; // максимальное количество входных бит для распознавания (1 столбец таблицы)
localparam max_bits_tabl; // максимальное количество распознанных бит (2 столбец таблицы)

reg clk_inp // тактовый сигнал, по которому считываем входные значения

wire input // вход для вашей тестовой последовательности
reg [3:0] output // выход

reg [max_bits_in-1:0] SR_in // входной сдвиговый регистр
reg [max_bits_tabl*2-1:0] SR_out // сдвиговый регистр распознанных табличных значений (выходной), взят с выходной задержкой, чтобы могло уместиться 2 распознанных значения максимального размера.

reg [log2(max_bits_in)-1:0] shift; // число распознанных из SR_in бит

reg SR_in_change // сигнал изменения значения SR_in (изменение этого сигнала означает: заполнение входного регистра в этом такте закончено)
reg SR_out_change // сигнал изменения значения SR_out (изменение этого сигнала означает: распознавание в текущем такте закончено)

reg [log2(max_bits_in)-1:0] SR_in_MSB // указатель на текущий старший значащий разряд SR_in
reg [log2(max_bits_tabl)-1:0] SR_out_MSB

reg [log2(max_bits_in)-1:0] in_latency_cntr // счётчик задержки начала распознавания

        Порядок действий:
    1) Задвигаем на каждом такте clk_inp входной бит во входной сдвиговый регистр. 
    2) Производим распознавание текущей полученной последовательности. В зависимости от текущего значения SR_in_MSB выбираем часть входного регистра SR_in [SR_in_MSB-1:0] для распознавания. Для каждого из случаев значения SR_in_MSB делаем case/casez на текущие возможные значения, которые могут быть распознаны.
    3) по изменению счётчика распознанных бит подсчитать новое количество значащих бит входного регистра SR_in_MSB – это нужно для того, чтобы не распознавать 2 раза одни и те же биты сдвигового регистра, а двигаться по нему, не беря в рассмотрение уже распознанные на предыдущем такте биты.

Также необходимо обеспечить задержку в первые 4 такта, чтобы входной регистр успел заполниться значениями, иначе будем пытаться распознать мусор. Это реализуется отдельным счётчиком задержки in_latency_cntr. 
