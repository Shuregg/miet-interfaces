# miet-interfaces
Код RLL
Другое название кода - RLL-код с ограничением длины поля записи (Run Length Limit - RLL). Это семейство методов кодирования.
Отличия внутри семейства определяются двумя параметрами: run length - минимальное количество битовых интервалов между сменами полярности напряжения, и run limit - максимальное количество битовых интервалов без смены полярности.
Рассмотрим популярный вариант RLL - RLL (2,7). Для него составляется словарь кодирования.

Битовая последовательность,	Кодированная последовательность,	Количество смен полярности на бит,	Вероятность встречи в случайном потоке данных, %
11	                        RNNN	                            1/2	                                25
10	                        NRNN	                            1/2	                                25
011	                        NNRNNN	                          1/3	                                12,5
010	                        RNNRNN	                          2/3	                                12,5
000	                        NNNRNN	                          1/3	                                12,5
0010	                      NNRNNRNN	                        2/4	                                6,25
0011	                      NNNNRNNN	                        1/4	                                6,25

Примечание: R - смена полярности в начале полутакта; N - полярность не меняется.
![изображение](https://github.com/Shuregg/miet-interfaces/assets/47576452/99da126e-ac8f-404d-887f-86c3ea507798)
