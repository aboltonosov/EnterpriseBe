﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда
	
		Возврат;
	
	КонецЕсли;

	Результат = РеквизитФормыВЗначение("ИсторияКлассификации");

	Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	Периоды.Период КАК Период,
		|	ВЫБОР
		|		КОГДА XYZПрибыль.Класс ЕСТЬ NULL 
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СтадииВзаимоотношенийСКлиентами.ПотенциальныйКлиент)
		|		КОГДА XYZПрибыль.Класс = ЗНАЧЕНИЕ(Перечисление.XYZКлассификация.ZКласс)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СтадииВзаимоотношенийСКлиентами.РазовыйКлиент)
		|		КОГДА XYZПрибыль.Класс = ЗНАЧЕНИЕ(Перечисление.XYZКлассификация.НеКлассифицирован)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СтадииВзаимоотношенийСКлиентами.ПотерянныйКлиент)
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.СтадииВзаимоотношенийСКлиентами.ПостоянныйКлиент)
		|	КОНЕЦ КАК СтадияПрибыль,
		|	ABCПрибыль.Класс КАК ABCПрибыль,
		|	XYZПрибыль.Класс КАК XYZПрибыль,
		|	ВЫБОР
		|		КОГДА XYZВыручка.Класс ЕСТЬ NULL 
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СтадииВзаимоотношенийСКлиентами.ПотенциальныйКлиент)
		|		КОГДА XYZВыручка.Класс = ЗНАЧЕНИЕ(Перечисление.XYZКлассификация.ZКласс)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СтадииВзаимоотношенийСКлиентами.РазовыйКлиент)
		|		КОГДА XYZВыручка.Класс = ЗНАЧЕНИЕ(Перечисление.XYZКлассификация.НеКлассифицирован)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СтадииВзаимоотношенийСКлиентами.ПотерянныйКлиент)
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.СтадииВзаимоотношенийСКлиентами.ПостоянныйКлиент)
		|	КОНЕЦ КАК СтадияВыручка,
		|	ABCВыручка.Класс КАК ABCВыручка,
		|	XYZВыручка.Класс КАК XYZВыручка,
		|	ВЫБОР
		|		КОГДА XYZКоличество.Класс ЕСТЬ NULL 
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СтадииВзаимоотношенийСКлиентами.ПотенциальныйКлиент)
		|		КОГДА XYZКоличество.Класс = ЗНАЧЕНИЕ(Перечисление.XYZКлассификация.ZКласс)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СтадииВзаимоотношенийСКлиентами.РазовыйКлиент)
		|		КОГДА XYZКоличество.Класс = ЗНАЧЕНИЕ(Перечисление.XYZКлассификация.НеКлассифицирован)
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СтадииВзаимоотношенийСКлиентами.ПотерянныйКлиент)
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.СтадииВзаимоотношенийСКлиентами.ПостоянныйКлиент)
		|	КОНЕЦ КАК СтадияКоличество,
		|	ABCКоличество.Класс КАК ABCКоличество,
		|	XYZКоличество.Класс КАК XYZКоличество
		|ИЗ
		|	(ВЫБРАТЬ
		|		ABCXYZКлассификацияКлиентов.Период КАК Период
		|	ИЗ
		|		РегистрСведений.ABCXYZКлассификацияКлиентов КАК ABCXYZКлассификацияКлиентов
		|	ГДЕ
		|		ABCXYZКлассификацияКлиентов.Партнер = &Партнер
		|	
		|	СГРУППИРОВАТЬ ПО
		|		ABCXYZКлассификацияКлиентов.Период) КАК Периоды
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ABCXYZКлассификацияКлиентов КАК ABCПрибыль
		|		ПО Периоды.Период = ABCПрибыль.Период
		|			И (ABCПрибыль.Партнер = &Партнер)
		|			И (ABCПрибыль.ТипКлассификации = ЗНАЧЕНИЕ(Перечисление.ТипыКлассификации.ABC))
		|			И (ABCПрибыль.ТипПараметраКлассификации = ЗНАЧЕНИЕ(Перечисление.ТипыПараметровКлассификации.ВаловаяПрибыль))
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ABCXYZКлассификацияКлиентов КАК ABCВыручка
		|		ПО Периоды.Период = ABCВыручка.Период
		|			И (ABCВыручка.Партнер = &Партнер)
		|			И (ABCВыручка.ТипКлассификации = ЗНАЧЕНИЕ(Перечисление.ТипыКлассификации.ABC))
		|			И (ABCВыручка.ТипПараметраКлассификации = ЗНАЧЕНИЕ(Перечисление.ТипыПараметровКлассификации.Выручка))
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ABCXYZКлассификацияКлиентов КАК ABCКоличество
		|		ПО Периоды.Период = ABCКоличество.Период
		|			И (ABCКоличество.Партнер = &Партнер)
		|			И (ABCКоличество.ТипКлассификации = ЗНАЧЕНИЕ(Перечисление.ТипыКлассификации.ABC))
		|			И (ABCКоличество.ТипПараметраКлассификации = ЗНАЧЕНИЕ(Перечисление.ТипыПараметровКлассификации.Количество))
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ABCXYZКлассификацияКлиентов КАК XYZПрибыль
		|		ПО Периоды.Период = XYZПрибыль.Период
		|			И (XYZПрибыль.Партнер = &Партнер)
		|			И (XYZПрибыль.ТипКлассификации = ЗНАЧЕНИЕ(Перечисление.ТипыКлассификации.XYZ))
		|			И (XYZПрибыль.ТипПараметраКлассификации = ЗНАЧЕНИЕ(Перечисление.ТипыПараметровКлассификации.ВаловаяПрибыль))
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ABCXYZКлассификацияКлиентов КАК XYZВыручка
		|		ПО Периоды.Период = XYZВыручка.Период
		|			И (XYZВыручка.Партнер = &Партнер)
		|			И (XYZВыручка.ТипКлассификации = ЗНАЧЕНИЕ(Перечисление.ТипыКлассификации.XYZ))
		|			И (XYZВыручка.ТипПараметраКлассификации = ЗНАЧЕНИЕ(Перечисление.ТипыПараметровКлассификации.Выручка))
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ABCXYZКлассификацияКлиентов КАК XYZКоличество
		|		ПО Периоды.Период = XYZКоличество.Период
		|			И (XYZКоличество.Партнер = &Партнер)
		|			И (XYZКоличество.ТипКлассификации = ЗНАЧЕНИЕ(Перечисление.ТипыКлассификации.XYZ))
		|			И (XYZКоличество.ТипПараметраКлассификации = ЗНАЧЕНИЕ(Перечисление.ТипыПараметровКлассификации.Количество))
		|
		|УПОРЯДОЧИТЬ ПО
		|	Период");
	Запрос.УстановитьПараметр("Партнер", Параметры.Партнер);
	Выборка = Запрос.Выполнить();
	КоличествоПолей = Выборка.Колонки.Количество() - 1;

	Если Не Выборка.Пустой() Тогда

		//заполнить историю классификации
		ПрошлыйСрез = Неопределено;
		Выборка = Выборка.Выбрать();
		Пока Выборка.Следующий() Цикл

			//сформировать срез на дату классификации
			Срез = Новый Массив;
			Для счПолей = 0 По КоличествоПолей Цикл
				Срез.Добавить(Выборка.Получить(счПолей));
			КонецЦикла;

			//добавить строку при изменении текущих результатов классификации
			Если ПрошлыйСрез = Неопределено Тогда
				ВставитьСтроку(Срез, Результат);
			Иначе
				СрезИзменился = Ложь;
				Для счПолей = 1 По КоличествоПолей Цикл
					ТекущееЗначение = Срез.Получить(счПолей);
					ПрошлоеЗначение = ПрошлыйСрез.Получить(счПолей);
					Если ТекущееЗначение <> ПрошлоеЗначение Тогда
						Если ПрошлоеЗначение = Перечисления.СтадииВзаимоотношенийСКлиентами.ПотерянныйКлиент
						 Или ПрошлоеЗначение = Перечисления.ABCКлассификация.НеКлассифицирован
						 Или ПрошлоеЗначение = Перечисления.XYZКлассификация.НеКлассифицирован Тогда
							ТекущееЗначение = ПрошлоеЗначение;
						Иначе
							ПрошлыйСрез = Срез;
							ВставитьСтроку(Срез, Результат);
							Прервать;
						КонецЕсли;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли; //добавить строку при изменении текущих результатов классификации
		КонецЦикла; //заполнить историю классификации

		//добавить строку регистрации клиента
		Строка = Результат.Добавить();
		Строка.ДатаИзменения    = Параметры.Партнер.ДатаРегистрации;
		Строка.Выручка          = НСтр("ru = 'Потенциальный клиент'");
		Строка.ВаловаяПрибыль   = Строка.Выручка;
		Строка.КоличествоПродаж = Строка.Выручка;

	КонецЕсли;

	//скрыть неиспользуемые столбцы
	Элементы.ИсторияКлассификацииВыручка.Видимость = 
		ПолучитьФункциональнуюОпцию("ИспользоватьABCXYZКлассификациюПартнеровПоВыручке");
	Элементы.ИсторияКлассификацииВаловаяПрибыль.Видимость =
		ПолучитьФункциональнуюОпцию("ИспользоватьABCXYZКлассификациюПартнеровПоВаловойПрибыли");
	Элементы.ИсторияКлассификацииКоличествоПродаж.Видимость =
		ПолучитьФункциональнуюОпцию("ИспользоватьABCXYZКлассификациюПартнеровПоКоличествуПродаж");

	ЗначениеВРеквизитФормы(Результат, "ИсторияКлассификации");

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Процедура ВставитьСтроку(Срез, Результат)

	Строка = Результат.Вставить(0);
	Строка.ДатаИзменения = Срез.Получить(0);
	Строка.ВаловаяПрибыль   = ПредставлениеКласса(Срез.Получить(1), Срез.Получить(2), Срез.Получить(3));
	Строка.Выручка          = ПредставлениеКласса(Срез.Получить(4), Срез.Получить(5), Срез.Получить(6));
	Строка.КоличествоПродаж = ПредставлениеКласса(Срез.Получить(7), Срез.Получить(8), Срез.Получить(9));

КонецПроцедуры

&НаСервере
Функция ПредставлениеКласса(Стадия, ABCКласс, XYZКласс)

	Результат = Строка(Стадия);
	ПредставлениеABC = "";
	ПредставлениеXYZ = "";

	Если ABCКласс = Перечисления.ABCКлассификация.AКласс Тогда

		ПредставлениеABC = "A";

	ИначеЕсли ABCКласс = Перечисления.ABCКлассификация.BКласс Тогда

		ПредставлениеABC = "B";

	ИначеЕсли ABCКласс = Перечисления.ABCКлассификация.CКласс Тогда

		ПредставлениеABC = "C";

	КонецЕсли;

	Если XYZКласс = Перечисления.XYZКлассификация.XКласс Тогда

		ПредставлениеXYZ = "X";

	ИначеЕсли XYZКласс = Перечисления.XYZКлассификация.YКласс Тогда

		ПредставлениеXYZ = "Y";

	ИначеЕсли XYZКласс = Перечисления.XYZКлассификация.ZКласс Тогда

		ПредставлениеXYZ = "Z";

	КонецЕсли;

	Если ПредставлениеABC <> "" Или ПредставлениеXYZ <> "" Тогда
		Результат = Результат + ", " + ПредставлениеABC + ПредставлениеXYZ;
	КонецЕсли;

	Возврат Результат;

КонецФункции

#КонецОбласти

#КонецОбласти
