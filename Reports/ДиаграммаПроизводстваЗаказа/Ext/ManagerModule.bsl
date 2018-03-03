﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Формирует отчет.
//
// Параметры:
//  Параметры  - Структура - параметры формирования отчета.
//		* ЭтапПроизводства - ДокументСсылка.ЭтапПроизводства2_2 - диагностируемый этап.
//		* СтатусГрафика - Число - статус диагностируемого графика.
//		* РежимОтображения - Число - режим отображения отчета (см. функцию РежимыОтображения).
//  АдресХранилища - Строка - адрес хранилища, в которое будет помещен результат формирования отчета.
//
Процедура СформироватьОтчет(Параметры, АдресХранилища) Экспорт
	
	ДиаграммаГанта = Новый ДиаграммаГанта;
	
	НастроитьОбщиеСвойстваДиаграммы(ДиаграммаГанта);
	
	Распоряжение = Параметры.Распоряжение;
	РежимОтображения = Параметры.РежимОтображения;
	СтатусГрафика = Параметры.СтатусГрафика;
	Границы = Новый Структура("Начало, Окончание", '39991231', '00010101');
	
	Если РежимОтображения = РежимПоПодразделениям()
		ИЛИ РежимОтображения = РежимПоВидамРабочихЦентров() Тогда
		
		СформироватьОтчетПоИсполнителям(ДиаграммаГанта, Распоряжение, РежимОтображения, СтатусГрафика, Границы);
		
	ИначеЕсли РежимОтображения = РежимПоПартиямЗапуска() Тогда
		
		СформироватьОтчетПоПартиямЗапуска(ДиаграммаГанта, Распоряжение, СтатусГрафика, Границы);
		
	КонецЕсли;
	
	НастроитьШкалуВремениДиаграммы(ДиаграммаГанта, Границы);
	
	ПоместитьВоВременноеХранилище(ДиаграммаГанта, АдресХранилища);
	
КонецПроцедуры

// Возвращает режимы отображения отчета.
// 
// Возвращаемое значение:
//  СписокЗначений - список, в котором значение - это числовой код режима,
//		а представление - представление режима.
//
Функция РежимыОтображения() Экспорт
	
	Результат = Новый СписокЗначений;
	
	Результат.Добавить(
		РежимПоПодразделениям(),
		НСтр("ru = 'По подразделениям'"));
		
	Результат.Добавить(
		РежимПоВидамРабочихЦентров(),
		НСтр("ru = 'По видам рабочих центров'"));
		
	Результат.Добавить(
		РежимПоПартиямЗапуска(),
		НСтр("ru = 'По партиям запуска'"));
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПоПодразделениямИВидамРабочихЦентров

Процедура СформироватьОтчетПоИсполнителям(ДиаграммаГанта, Распоряжение, РежимОтображения, СтатусГрафика, Границы)
	
	ДиаграммаГанта.Обновление = Ложь;
	
	График = ГрафикПоИсполнителям(Распоряжение, РежимОтображения, СтатусГрафика, Границы);
	
	Серия = СерияПоУмолчанию(ДиаграммаГанта);
	
	Исполнитель = Неопределено;
	Для Индекс = 0 По График.Количество()-1 Цикл
		
		Строка = График[Индекс];
		Если Исполнитель = Неопределено
			ИЛИ НЕ Исполнитель = Строка.Исполнитель Тогда
			
			Точка = УстановитьТочкуИсполнитель(ДиаграммаГанта, Строка);
			Значение = ДиаграммаГанта.ПолучитьЗначение(Точка, Серия);
			
		КонецЕсли;
		
		ДобавитьИнтервалИсполнитель(Значение, Строка);
		
	КонецЦикла;
	
	ДиаграммаГанта.Обновление = Ложь;
	
КонецПроцедуры

Функция ГрафикПоИсполнителям(Распоряжение, РежимОтображения, СтатусГрафика, Границы)
	
	Результат = ИнициализироватьГрафикПоИсполнителям();
	
	Запрос = ИнициализироватьЗапросПоИсполнителям(Распоряжение, РежимОтображения, СтатусГрафика);
	
	ВыборкаИтоги = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Если ВыборкаИтоги.Следующий() Тогда
		
		ЗаполнитьЗначенияСвойств(Границы, ВыборкаИтоги);
		
		ВыборкаИсполнитель = ВыборкаИтоги.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаИсполнитель.Следующий() Цикл
			
			ПредыдущаяСтрока = Неопределено;
			
			Выборка = ВыборкаИсполнитель.Выбрать();
			Пока Выборка.Следующий() Цикл
				
				Если ПредыдущаяСтрока = Неопределено
					ИЛИ (ПредыдущаяСтрока.Окончание + 1) < Выборка.Начало Тогда
					
					НоваяСтрока = Результат.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
					
					ПредыдущаяСтрока = НоваяСтрока;
					
				Иначе
					
					ПредыдущаяСтрока.Окончание = Макс(ПредыдущаяСтрока.Окончание, Выборка.Окончание);
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ИнициализироватьГрафикПоИсполнителям()
	
	ТипыИсполнителей = Новый Массив;
	ТипыИсполнителей.Добавить(Тип("СправочникСсылка.СтруктураПредприятия"));
	ТипыИсполнителей.Добавить(Тип("СправочникСсылка.ВидыРабочихЦентров"));
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("Исполнитель", Новый ОписаниеТипов(ТипыИсполнителей));
	Результат.Колонки.Добавить("Представление", Новый ОписаниеТипов("Строка"));
	Результат.Колонки.Добавить("Начало", Новый ОписаниеТипов("Дата"));
	Результат.Колонки.Добавить("Окончание", Новый ОписаниеТипов("Дата"));
	
	Возврат Результат;
	
КонецФункции

Функция ИнициализироватьЗапросПоИсполнителям(Распоряжение, РежимОтображения, СтатусГрафика)
	
	Если РежимОтображения = РежимПоПодразделениям() Тогда
		ТекстЗапроса = ТекстЗапросаГрафикПоПодразделениям(СтатусГрафика);
	Иначе
		ТекстЗапроса = ТекстЗапросаГрафикПоВидамРЦ(СтатусГрафика);
	КонецЕсли;
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Распоряжение", Распоряжение);
	Запрос.УстановитьПараметр("СтатусГрафика", СтатусГрафика);
	Запрос.УстановитьПараметр("СтатусРабочийГрафик", СтатусРабочийГрафик());
	
	Возврат Запрос;
	
КонецФункции

Функция ТекстЗапросаГрафикПоПодразделениям(СтатусГрафика)
	
	Если СтатусГрафика = СтатусРабочийГрафик() Тогда
		
		Результат = 
		"ВЫБРАТЬ
		|	ГрафикЭтаповПроизводства2_2.ЭтапПроизводства.Подразделение КАК Исполнитель,
		|	ГрафикЭтаповПроизводства2_2.ЭтапПроизводства.Подразделение.Представление КАК Представление,
		|	ГрафикЭтаповПроизводства2_2.НачалоЭтапа КАК Начало,
		|	ГрафикЭтаповПроизводства2_2.ОкончаниеЭтапа КАК Окончание
		|ИЗ
		|	РегистрСведений.ГрафикЭтаповПроизводства2_2 КАК ГрафикЭтаповПроизводства2_2
		|ГДЕ
		|	ГрафикЭтаповПроизводства2_2.Распоряжение = &Распоряжение
		|	И ГрафикЭтаповПроизводства2_2.СтатусГрафика = &СтатусГрафика
		|
		|УПОРЯДОЧИТЬ ПО
		|	Исполнитель,
		|	Начало,
		|	Окончание
		|ИТОГИ
		|	МИНИМУМ(Начало),
		|	МАКСИМУМ(Окончание)
		|ПО
		|	ОБЩИЕ,
		|	Исполнитель";
		
	Иначе
		
		Результат = 
		"ВЫБРАТЬ
		|	ГрафикЭтаповПроизводства2_2.ЭтапПроизводства,
		|	ГрафикЭтаповПроизводства2_2.ЭтапПроизводства.Подразделение КАК Исполнитель,
		|	ГрафикЭтаповПроизводства2_2.НачалоЭтапа КАК Начало,
		|	ГрафикЭтаповПроизводства2_2.ОкончаниеЭтапа КАК Окончание
		|ПОМЕСТИТЬ ВТГрафик
		|ИЗ
		|	РегистрСведений.ГрафикЭтаповПроизводства2_2 КАК ГрафикЭтаповПроизводства2_2
		|ГДЕ
		|	ГрафикЭтаповПроизводства2_2.Распоряжение = &Распоряжение
		|	И ГрафикЭтаповПроизводства2_2.СтатусГрафика = &СтатусГрафика
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТГрафик.Исполнитель КАК Исполнитель,
		|	ВТГрафик.Исполнитель.Представление КАК Представление,
		|	ВТГрафик.Начало КАК Начало,
		|	ВТГрафик.Окончание КАК Окончание
		|ИЗ
		|	ВТГрафик КАК ВТГрафик
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ГрафикЭтаповПроизводства2_2.ЭтапПроизводства.Подразделение,
		|	ГрафикЭтаповПроизводства2_2.ЭтапПроизводства.Подразделение.Представление,
		|	ГрафикЭтаповПроизводства2_2.НачалоЭтапа,
		|	ГрафикЭтаповПроизводства2_2.ОкончаниеЭтапа
		|ИЗ
		|	РегистрСведений.ГрафикЭтаповПроизводства2_2 КАК ГрафикЭтаповПроизводства2_2
		|ГДЕ
		|	ГрафикЭтаповПроизводства2_2.Распоряжение = &Распоряжение
		|	И ГрафикЭтаповПроизводства2_2.СтатусГрафика = &СтатусРабочийГрафик
		|	И НЕ ГрафикЭтаповПроизводства2_2.ЭтапПроизводства В
		|				(ВЫБРАТЬ
		|					ВТГРафик.ЭтапПроизводства
		|				ИЗ
		|					ВТГРафик)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Исполнитель,
		|	Начало,
		|	Окончание
		|ИТОГИ
		|	МИНИМУМ(Начало),
		|	МАКСИМУМ(Окончание)
		|ПО
		|	ОБЩИЕ,
		|	Исполнитель";
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ТекстЗапросаГрафикПоВидамРЦ(СтатусГрафика)
	
	Если СтатусГрафика = СтатусРабочийГрафик() Тогда
		
		Результат = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВЫРАЗИТЬ(ДоступностьВидовРабочихЦентров.Регистратор КАК Документ.ЭтапПроизводства2_2) КАК ЭтапПроизводства,
		|	ДоступностьВидовРабочихЦентров.ВидРабочегоЦентра КАК Исполнитель
		|ПОМЕСТИТЬ ВТИсполнители
		|ИЗ
		|	РегистрНакопления.ДоступностьВидовРабочихЦентров КАК ДоступностьВидовРабочихЦентров
		|ГДЕ
		|	ДоступностьВидовРабочихЦентров.Регистратор ССЫЛКА Документ.ЭтапПроизводства2_2
		|	И ВЫРАЗИТЬ(ДоступностьВидовРабочихЦентров.Регистратор КАК Документ.ЭтапПроизводства2_2).Распоряжение = &Распоряжение
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ЭтапПроизводства
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТИсполнители.Исполнитель КАК Исполнитель,
		|	ВТИсполнители.Исполнитель.Представление КАК Представление,
		|	ГрафикЭтаповПроизводства2_2.НачалоЭтапа КАК Начало,
		|	ГрафикЭтаповПроизводства2_2.ОкончаниеЭтапа КАК Окончание
		|ИЗ
		|	РегистрСведений.ГрафикЭтаповПроизводства2_2 КАК ГрафикЭтаповПроизводства2_2
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТИсполнители КАК ВТИсполнители
		|		ПО ГрафикЭтаповПроизводства2_2.ЭтапПроизводства = ВТИсполнители.ЭтапПроизводства
		|			И (ГрафикЭтаповПроизводства2_2.СтатусГрафика = &СтатусГрафика)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Исполнитель,
		|	Начало,
		|	Окончание
		|ИТОГИ
		|	МИНИМУМ(Начало),
		|	МАКСИМУМ(Окончание)
		|ПО
		|	ОБЩИЕ,
		|	Исполнитель";
		
	Иначе
		
		Результат = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПланированиеЗагрузкиВидовРабочихЦентров.ЭтапПроизводства КАК ЭтапПроизводства,
		|	ПланированиеЗагрузкиВидовРабочихЦентров.ВидРабочегоЦентра КАК Исполнитель
		|ПОМЕСТИТЬ ВТИсполнителиПоСтатусу
		|ИЗ
		|	РегистрСведений.ПланированиеЗагрузкиВидовРабочихЦентров КАК ПланированиеЗагрузкиВидовРабочихЦентров
		|ГДЕ
		|	ПланированиеЗагрузкиВидовРабочихЦентров.Распоряжение = &Распоряжение
		|	И ПланированиеЗагрузкиВидовРабочихЦентров.СтатусГрафика = &СтатусГрафика
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ЭтапПроизводства
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВЫРАЗИТЬ(ДоступностьВидовРабочихЦентров.Регистратор КАК Документ.ЭтапПроизводства2_2) КАК ЭтапПроизводства,
		|	ДоступностьВидовРабочихЦентров.ВидРабочегоЦентра КАК Исполнитель
		|ПОМЕСТИТЬ ВТИсполнителиРабочийГрафик
		|ИЗ
		|	РегистрНакопления.ДоступностьВидовРабочихЦентров КАК ДоступностьВидовРабочихЦентров
		|ГДЕ
		|	ДоступностьВидовРабочихЦентров.Регистратор ССЫЛКА Документ.ЭтапПроизводства2_2
		|	И ВЫРАЗИТЬ(ДоступностьВидовРабочихЦентров.Регистратор КАК Документ.ЭтапПроизводства2_2).Распоряжение = &Распоряжение
		|	И НЕ ДоступностьВидовРабочихЦентров.Регистратор В
		|				(ВЫБРАТЬ
		|					ВТИсполнителиПоСтатусу.ЭтапПроизводства
		|				ИЗ
		|					ВТИсполнителиПоСтатусу)
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ЭтапПроизводства
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Исполнители.Исполнитель КАК Исполнитель,
		|	Исполнители.Исполнитель.Представление КАК Представление,
		|	ГрафикЭтаповПроизводства2_2.НачалоЭтапа КАК Начало,
		|	ГрафикЭтаповПроизводства2_2.ОкончаниеЭтапа КАК Окончание
		|ИЗ
		|	РегистрСведений.ГрафикЭтаповПроизводства2_2 КАК ГрафикЭтаповПроизводства2_2
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТИсполнителиПоСтатусу КАК Исполнители
		|		ПО ГрафикЭтаповПроизводства2_2.ЭтапПроизводства = Исполнители.ЭтапПроизводства
		|			И (ГрафикЭтаповПроизводства2_2.СтатусГрафика = &СтатусГрафика)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Исполнители.Исполнитель,
		|	Исполнители.Исполнитель.Представление,
		|	ГрафикЭтаповПроизводства2_2.НачалоЭтапа,
		|	ГрафикЭтаповПроизводства2_2.ОкончаниеЭтапа
		|ИЗ
		|	РегистрСведений.ГрафикЭтаповПроизводства2_2 КАК ГрафикЭтаповПроизводства2_2
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТИсполнителиРабочийГрафик КАК Исполнители
		|		ПО ГрафикЭтаповПроизводства2_2.ЭтапПроизводства = Исполнители.ЭтапПроизводства
		|			И (ГрафикЭтаповПроизводства2_2.СтатусГрафика = &СтатусРабочийГрафик)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Исполнитель,
		|	Начало,
		|	Окончание
		|ИТОГИ
		|	МИНИМУМ(Начало),
		|	МАКСИМУМ(Окончание)
		|ПО
		|	ОБЩИЕ,
		|	Исполнитель";
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция УстановитьТочкуИсполнитель(ДиаграммаГанта, Данные)
	
	Результат = ДиаграммаГанта.УстановитьТочку(Данные.Исполнитель);
	Результат.Текст = Данные.Представление;
	Результат.Расшифровка = Данные.Исполнитель;
	
	Возврат Результат;
	
КонецФункции

Процедура ДобавитьИнтервалИсполнитель(Значение, Данные)
	
	Интервал = Значение.Добавить();
	Интервал.Начало = Данные.Начало;
	Интервал.Конец = Данные.Окончание;
	Интервал.Текст = ТекстИнтервалаДиаграммы(Данные.Начало, Данные.Окончание);
	Интервал.Цвет = WebЦвета.Зеленый;
	
КонецПроцедуры

#КонецОбласти

#Область ПоПартиямЗапуска

Процедура СформироватьОтчетПоПартиямЗапуска(ДиаграммаГанта, Распоряжение, СтатусГрафика, Границы)
	
	ДиаграммаГанта.Обновление = Ложь;
	
	Данные = ГрафикИЗависимостиПоПартиямЗапуска(Распоряжение, СтатусГрафика);
	ВыборкаПартияЗапуска = Данные.ВыборкаПартияЗапуска;
	
	Если ВыборкаПартияЗапуска.Количество() > 0 Тогда
		
		Серия = СерияПоУмолчанию(ДиаграммаГанта);
		
		Интервалы = Новый ТаблицаЗначений;
		Интервалы.Колонки.Добавить("ВыпускающийЭтап");
		Интервалы.Колонки.Добавить("Интервал");
		
		Интервалы.Индексы.Добавить("ВыпускающийЭтап");
		
		Пока ВыборкаПартияЗапуска.Следующий() Цикл
			
			ВыборкаВыходныеИзделия = ВыборкаПартияЗапуска.Выбрать();
			ВыборкаВыходныеИзделия.Следующий();
			
			Границы.Начало = МИН(Границы.Начало, ВыборкаПартияЗапуска.Начало);
			Границы.Окончание = МАКС(Границы.Окончание, ВыборкаПартияЗапуска.Окончание);
			
			Точка = УстановитьТочкуПартияЗапуска(ДиаграммаГанта, ВыборкаПартияЗапуска, ВыборкаВыходныеИзделия);
			Значение = ДиаграммаГанта.ПолучитьЗначение(Точка, Серия);
			
			ВыборкаВыходныеИзделия.Сбросить();
			Интервал = ДобавитьИнтервалПартияЗапуска(Значение, ВыборкаПартияЗапуска, ВыборкаВыходныеИзделия);
			
			НоваяСтрока = Интервалы.Добавить();
			НоваяСтрока.ВыпускающийЭтап = ВыборкаПартияЗапуска.ВыпускающийЭтап;
			НоваяСтрока.Интервал = Интервал;
			
		КонецЦикла;
		
		// Связи между этапами.
		Для каждого СтрокаЗависимость Из Данные.Зависимости Цикл
			
			НайденнаяСтрока = Интервалы.Найти(СтрокаЗависимость.ВыпускающийЭтап, "ВыпускающийЭтап");
			Если НЕ НайденнаяСтрока = Неопределено Тогда
				
				Интервал = НайденнаяСтрока.Интервал;
				
				НайденнаяСтрока = Интервалы.Найти(СтрокаЗависимость.СледующийЭтап, "ВыпускающийЭтап");
				Если НЕ НайденнаяСтрока = Неопределено Тогда
					
					СледующийИнтервал = НайденнаяСтрока.Интервал;
					
					Связь = Интервал.Добавить(СледующийИнтервал);
					Связь.ТипСвязи = ТипСвязиДиаграммыГанта.КонецНачало;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	ДиаграммаГанта.Обновление = Ложь;
	
КонецПроцедуры

Функция ГрафикИЗависимостиПоПартиямЗапуска(Распоряжение, СтатусГрафика)
	
	ТекстыЗапросовПакета = Новый Массив;
	
	Если СтатусГрафика = СтатусРабочийГрафик() Тогда
		
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ГрафикЭтаповПроизводства2_2.ЭтапПроизводства.ВыпускающийЭтап КАК ВыпускающийЭтап,
		|	МИНИМУМ(ГрафикЭтаповПроизводства2_2.НачалоЭтапа) КАК Начало,
		|	МАКСИМУМ(ГрафикЭтаповПроизводства2_2.ОкончаниеЭтапа) КАК Окончание
		|ПОМЕСТИТЬ ВТВыпускающиеЭтапы
		|ИЗ
		|	РегистрСведений.ГрафикЭтаповПроизводства2_2 КАК ГрафикЭтаповПроизводства2_2
		|ГДЕ
		|	ГрафикЭтаповПроизводства2_2.Распоряжение = &Распоряжение
		|	И ГрафикЭтаповПроизводства2_2.СтатусГрафика = &СтатусГрафика
		|
		|СГРУППИРОВАТЬ ПО
		|	ГрафикЭтаповПроизводства2_2.ЭтапПроизводства.ВыпускающийЭтап
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ВыпускающийЭтап";
		
	Иначе
		
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ГрафикЭтаповПроизводства2_2.ЭтапПроизводства,
		|	ГрафикЭтаповПроизводства2_2.НачалоЭтапа,
		|	ГрафикЭтаповПроизводства2_2.ОкончаниеЭтапа
		|ПОМЕСТИТЬ ВТГрафикПоСтатусу
		|ИЗ
		|	РегистрСведений.ГрафикЭтаповПроизводства2_2 КАК ГрафикЭтаповПроизводства2_2
		|ГДЕ
		|	ГрафикЭтаповПроизводства2_2.Распоряжение = &Распоряжение
		|	И ГрафикЭтаповПроизводства2_2.СтатусГрафика = &СтатусГрафика
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВложенныйЗапрос.ЭтапПроизводства.ВыпускающийЭтап КАК ВыпускающийЭтап,
		|	МИНИМУМ(ВложенныйЗапрос.НачалоЭтапа) КАК Начало,
		|	МАКСИМУМ(ВложенныйЗапрос.ОкончаниеЭтапа) КАК Окончание
		|ПОМЕСТИТЬ ВТВыпускающиеЭтапы
		|ИЗ
		|	(ВЫБРАТЬ
		|		ВТГрафикПоСтатусу.ЭтапПроизводства КАК ЭтапПроизводства,
		|		ВТГрафикПоСтатусу.НачалоЭтапа КАК НачалоЭтапа,
		|		ВТГрафикПоСтатусу.ОкончаниеЭтапа КАК ОкончаниеЭтапа
		|	ИЗ
		|		ВТГрафикПоСтатусу КАК ВТГрафикПоСтатусу
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ГрафикЭтаповПроизводства2_2.ЭтапПроизводства,
		|		ГрафикЭтаповПроизводства2_2.НачалоЭтапа,
		|		ГрафикЭтаповПроизводства2_2.ОкончаниеЭтапа
		|	ИЗ
		|		РегистрСведений.ГрафикЭтаповПроизводства2_2 КАК ГрафикЭтаповПроизводства2_2
		|	ГДЕ
		|		ГрафикЭтаповПроизводства2_2.Распоряжение = &Распоряжение
		|		И ГрафикЭтаповПроизводства2_2.СтатусГрафика = &СтатусРабочийГрафик
		|		И НЕ ГрафикЭтаповПроизводства2_2.ЭтапПроизводства В
		|					(ВЫБРАТЬ
		|						ВТГРафикПоСтатусу.ЭтапПроизводства
		|					ИЗ
		|						ВТГРафикПоСтатусу)) КАК ВложенныйЗапрос
		|
		|СГРУППИРОВАТЬ ПО
		|	ВложенныйЗапрос.ЭтапПроизводства.ВыпускающийЭтап
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ВыпускающийЭтап";
		
	КонецЕсли;
	ТекстыЗапросовПакета.Добавить(ТекстЗапроса);
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВыходныеИзделия.Ссылка КАК ВыпускающийЭтап,
	|	ВыходныеИзделия.Номенклатура КАК Номенклатура,
	|	ЕСТЬNULL(ВыходныеИзделия.ЭтапПотребитель.ВыпускающийЭтап, ЗНАЧЕНИЕ(Документ.ЭтапПроизводства2_2.ПустаяСсылка)) КАК СледующийЭтап
	|ПОМЕСТИТЬ ВТВыходныеИзделия
	|ИЗ
	|	Документ.ЭтапПроизводства2_2.ВыходныеИзделия КАК ВыходныеИзделия
	|ГДЕ
	|	ВыходныеИзделия.Ссылка.Распоряжение = &Распоряжение
	|	И ВыходныеИзделия.Ссылка = ВыходныеИзделия.Ссылка.ВыпускающийЭтап
	|	И ВыходныеИзделия.Ссылка.Проведен
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ВыпускающийЭтап
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТВыпускающиеЭтапы.ВыпускающийЭтап КАК ВыпускающийЭтап,
	|	ВТВыпускающиеЭтапы.Начало КАК Начало,
	|	ВТВыпускающиеЭтапы.Окончание КАК Окончание,
	|	ВТВыходныеИзделия.Номенклатура КАК Номенклатура,
	|	ВТВыходныеИзделия.Номенклатура.Представление КАК НоменклатураПредставление
	|ИЗ
	|	ВТВыпускающиеЭтапы КАК ВТВыпускающиеЭтапы
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТВыходныеИзделия КАК ВТВыходныеИзделия
	|		ПО ВТВыпускающиеЭтапы.ВыпускающийЭтап = ВТВыходныеИзделия.ВыпускающийЭтап
	|
	|УПОРЯДОЧИТЬ ПО
	|	Начало,
	|	Окончание
	|ИТОГИ
	|	МИНИМУМ(Начало),
	|	МАКСИМУМ(Окончание),
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ Номенклатура)
	|ПО
	|	ВыпускающийЭтап
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВыходныеИзделия.ВыпускающийЭтап КАК ВыпускающийЭтап,
	|	ВыходныеИзделия.СледующийЭтап КАК СледующийЭтап
	|ИЗ
	|	ВТВыходныеИзделия КАК ВыходныеИзделия
	|ГДЕ
	|	ВыходныеИзделия.СледующийЭтап <> ЗНАЧЕНИЕ(Документ.ЭтапПроизводства2_2.ПустаяСсылка)";
	ТекстыЗапросовПакета.Добавить(ТекстЗапроса);
	
	Разделитель =
	"
	|;
	|/////////////////////////////////////////////////////////////
	|";
	ТекстЗапроса = СтрСоединить(ТекстыЗапросовПакета, Разделитель);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Распоряжение", Распоряжение);
	Запрос.УстановитьПараметр("СтатусГрафика", СтатусГрафика);
	Запрос.УстановитьПараметр("СтатусРабочийГрафик", СтатусРабочийГрафик());
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	МаксИндекс = МассивРезультатов.ВГраница();
	
	Результат = Новый Структура;
	
	ВыборкаПартияЗапуска = МассивРезультатов[МаксИндекс-1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Результат.Вставить("ВыборкаПартияЗапуска", ВыборкаПартияЗапуска);
	
	Зависимости = МассивРезультатов[МаксИндекс].Выгрузить();
	Результат.Вставить("Зависимости", Зависимости);
	
	Возврат Результат;
	
КонецФункции

Функция УстановитьТочкуПартияЗапуска(ДиаграммаГанта, ВыборкаПартияЗапуска, ДанныеВыходногоИзделия)
	
	ЗначениеТочки = ВыборкаПартияЗапуска.ВыпускающийЭтап;
	Результат = ДиаграммаГанта.УстановитьТочку(ЗначениеТочки);
	
	Текст = ДанныеВыходногоИзделия.НоменклатураПредставление;
	Если ВыборкаПартияЗапуска.Номенклатура > 1 Тогда
		Текст = Текст + " " + СтрШаблон(НСтр("ru = '+ выходные изделия (%1)'"), ВыборкаПартияЗапуска.Номенклатура-1);
	КонецЕсли;
	
	Результат.Текст = Текст;
	
	Результат.Расшифровка = ВыборкаПартияЗапуска.ВыпускающийЭтап;
	
	Возврат Результат;
	
КонецФункции

Функция ДобавитьИнтервалПартияЗапуска(Значение, ВыборкаПартияЗапуска, ВыборкаВыходныеИзделия)
	
	Результат = Значение.Добавить();
	Результат.Начало = ВыборкаПартияЗапуска.Начало;
	Результат.Конец = ВыборкаПартияЗапуска.Окончание;
	Результат.Текст = ТекстИнтервалаДиаграммы(
		ВыборкаПартияЗапуска.Начало, ВыборкаПартияЗапуска.Окончание);
	
	Расшифровка = Новый Структура;
	
	Расшифровка.Вставить("ВыпускающийЭтап", ВыборкаПартияЗапуска.ВыпускающийЭтап);
	
	МассивВыходныеИзделия = Новый Массив;
	Пока ВыборкаВыходныеИзделия.Следующий() Цикл
		Если МассивВыходныеИзделия.Найти(ВыборкаВыходныеИзделия.Номенклатура) = Неопределено Тогда
			МассивВыходныеИзделия.Добавить(ВыборкаВыходныеИзделия.Номенклатура);
		КонецЕсли;
	КонецЦикла;
	Расшифровка.Вставить("МассивВыходныеИзделия", МассивВыходныеИзделия);
	
	Результат.Расшифровка = Расшифровка;
	
	Результат.Цвет = WebЦвета.Зеленый;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область Прочее

Функция РежимПоПодразделениям()
	
	Возврат 0;
	
КонецФункции

Функция РежимПоВидамРабочихЦентров()
	
	Возврат 1;
	
КонецФункции

Функция РежимПоПартиямЗапуска()

	Возврат 2;
	
КонецФункции

Процедура НастроитьОбщиеСвойстваДиаграммы(ДиаграммаГанта)
	
	ДиаграммаГанта.АвтоОпределениеПолногоИнтервала = Ложь;
	ДиаграммаГанта.ПоддержкаМасштаба = ПоддержкаМасштабаДиаграммыГанта.ВсеДанные;
	ДиаграммаГанта.Окантовка = Ложь;
	ДиаграммаГанта.ОтображатьЛегенду = Ложь;
	ДиаграммаГанта.ВертикальнаяПрокрутка = Истина;
	ДиаграммаГанта.ОтображатьПустыеЗначения = Ложь;
	ДиаграммаГанта.ОтображатьЗаголовок = Ложь;
	ДиаграммаГанта.ОтображениеТекстаЗначения = ОтображениеТекстаЗначенияДиаграммыГанта.НеОтображать;
	ДиаграммаГанта.ОбластьПостроения.Право = 1;
	
КонецПроцедуры

Функция СтатусРабочийГрафик()
	
	Возврат РегистрыСведений.ГрафикЭтаповПроизводства2_2.СтатусРабочийГрафик();
	
КонецФункции

Функция СерияПоУмолчанию(ДиаграммаГанта)
	
	Возврат ДиаграммаГанта.УстановитьСерию("ГрафикПроизводства");
	
КонецФункции

Процедура НастроитьШкалуВремениДиаграммы(ДиаграммаГанта, Границы)
	
	Если НЕ ЗначениеЗаполнено(Границы.Окончание) Тогда
		Возврат;
	КонецЕсли;
	
	НастройкиШкалы = УправлениеПроизводствомКлиентСервер.НастройкиШкалыДиаграммыГантаВРежимеВсеДанные(
		Границы.Начало, Границы.Окончание, 9);
	
	ШкалаВремениЭлементы = ДиаграммаГанта.ОбластьПостроения.ШкалаВремени.Элементы;
	
	Для Индекс = 1 По ШкалаВремениЭлементы.Количество()-1 Цикл
		ШкалаВремениЭлементы.Удалить(ШкалаВремениЭлементы[Индекс]);
	КонецЦикла;
	
	ЭлементШкалы = ШкалаВремениЭлементы.Добавить();
	ЭлементШкалы.Единица = НастройкиШкалы.Единица;
	ЭлементШкалы.Формат = НастройкиШкалы.Формат;
	
	Если ШкалаВремениЭлементы.Количество() = 2 Тогда
		ШкалаВремениЭлементы.Удалить(ШкалаВремениЭлементы[0]);
	КонецЕсли;
	
	ДиаграммаГанта.УстановитьПолныйИнтервал(
		НастройкиШкалы.НачалоПолногоИнтервала,
		НастройкиШкалы.ОкончаниеПолногоИнтервала);
	
КонецПроцедуры

Функция ТекстИнтервалаДиаграммы(Начало, Окончание)
	
	ФорматнаяСтрока = УправлениеПроизводством.ФорматнаяСтрокаДляДатыГрафикаПроизводства();
	ФорматНачало = Формат(Начало, ФорматнаяСтрока);
	ФорматОкончание = Формат(Окончание, ФорматнаяСтрока);
	
	Если ФорматНачало = ФорматОкончание Тогда
		Результат = ФорматНачало;
	Иначе
		Результат = ФорматНачало + " - " + ФорматОкончание;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли