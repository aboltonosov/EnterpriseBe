﻿////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Форма параметризуется:
//     УзелИнформационнойБазы - ПланОбменаСсылка                      - узел обмена, для которого происходит настройка
//     ПериодОтбора           - СтандартныйПериод                     - общий период отбора
//     Отбор                  - ДанныеФормыКолелкция, ТаблицаЗначений - описание отбора для редактирования.
//                                При описании отбора используются колонки:
//                                    ПолноеИмяМетаданных - Строка                - имя метаданных, для отбора
//                                    Отбор               - ОтборКомпоновкиДанных - описание отбора
//                                    ВыборПериода        - Булево                - Истина, если применим общий период отбора
//                                    Период              - СтандартныйПериод     - общий период отбора для строки
//
// Форма должна вернуть результатом выбора структуру с полями:
//     ПредставлениеОтбора - Строка                                - текстовое описание отбора
//     ПериодОтбора        - СтандартныйПериод                     - общий период выбора, если используется
//     Отбор               - ДанныеФормыКоллекция, ТаблицаЗначений - заполненные данные
//                           Используются колонки аналогичные входному параметру: 
//                           ПолноеИмяМетаданных, Отбор, ВыборПериода, Период
//

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УзелИнформационнойБазы = Параметры.УзелИнформационнойБазы ;
	ПериодОтбора           = Параметры.ПериодОтбора;
	
	// Все возможные организации
	Для Каждого ЭлементСписка Из ДоступныеОрганизацииУзла(УзелИнформационнойБазы) Цикл
		ЗаполнитьЗначенияСвойств(СписокОрганизаций.Добавить(), ЭлементСписка);
	КонецЦикла;
	
	// Расставляем пометки, согласно входящему параметру
	УстановитьПомеченные(Параметры.Отбор);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьОтмеченные(Команда)
	ОповеститьОВыборе(РезультатВыбора());
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ДоступныеОрганизацииУзла(УзелИнформационнойБазы)
	
	Если УзелИнформационнойБазы.ИспользоватьОтборПоОрганизациям Тогда
		// Организации из табличной части 
		ЗапросИсточника = Новый Запрос(
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ОрганизацииПланаОбмена.Организация              КАК Организация,
			|	ОрганизацииПланаОбмена.Организация.Наименование КАК Наименование
			|ИЗ
			|	ПланОбмена.СинхронизацияДанныхЧерезУниверсальныйФормат.Организации КАК ОрганизацииПланаОбмена
			|ГДЕ
			|	ОрганизацииПланаОбмена.Ссылка = &Получатель");
		ЗапросИсточника.УстановитьПараметр("Получатель", УзелИнформационнойБазы);
	Иначе
		// Все доступные организации
		ЗапросИсточника = Новый Запрос(
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	Организации.Ссылка       КАК Организация,
			|	Организации.Наименование КАК Наименование
			|ИЗ
			|	Справочник.Организации КАК Организации
			|ГДЕ
			|	НЕ Организации.ПометкаУдаления");
	КонецЕсли;
	
	Результат = Новый СписокЗначений;
	
	Выборка = ЗапросИсточника.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Результат.Добавить(Выборка.Организация, Выборка.Наименование);
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

&НаСервере
Процедура УстановитьПомеченные(Знач ТаблицаОтбора)
	
	Если ТаблицаОтбора.Количество()=0 Или ТаблицаОтбора[0].Отбор.Элементы.Количество()=0 Тогда
		// Нет данных отбора
		Возврат;
	КонецЕсли;
		
	// Мы знаем состав отбора, так как помещали туда сами - или из менджера узла, или как результат 
	// редактирования в этой же форме
	
	СтрокаДанных = ТаблицаОтбора[0].Отбор.Элементы[0];
	Отобранные   = СтрокаДанных.ПравоеЗначение;
	ТипКоллекции = ТипЗнч(Отобранные);
	
	Если ТипКоллекции=Тип("СписокЗначений") Тогда
		Для Каждого Элемент Из Отобранные Цикл
			УстановитьМассивПомеченных(Элемент.Значение);
		КонецЦикла;
		
	ИначеЕсли ТипКоллекции=Тип("Массив") Тогда
		 УстановитьМассивПомеченных(Отобранные);
		 
	ИначеЕсли ТипКоллекции=Тип("СправочникСсылка.Организации") Тогда
		ЭлементСписка = СписокОрганизаций.НайтиПоЗначению(Отобранные);
		Если ЭлементСписка<>Неопределено Тогда
			ЭлементСписка.Пометка = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьМассивПомеченных(Организации)
	Для Каждого Организация Из Организации Цикл
		Если ТипЗнч(Организация)=Тип("Массив") Тогда
			УстановитьМассивПомеченных(Организация);
			Продолжить;
		КонецЕсли;
		ЭлементСписка = СписокОрганизаций.НайтиПоЗначению(Организация);
		Если ЭлементСписка<>Неопределено Тогда
			ЭлементСписка.Пометка = Истина;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Функция РезультатВыбора()
	
	Результат = Новый Структура;
	Результат.Вставить("ПериодОтбора", ПериодОтбора);
	
	ТаблицаОтбора.Очистить();
	Результат.Вставить("Отбор", ТаблицаОтбора);

	МассивВыбранныхОрганизаций = Новый Массив;
	ОтборПоОрганизацииСтрокой = "";
	
	Для Каждого ЭлементСписка Из СписокОрганизаций Цикл
		Если ЭлементСписка.Пометка Тогда
			МассивВыбранныхОрганизаций.Добавить(ЭлементСписка.Значение);
			ОтборПоОрганизацииСтрокой = ОтборПоОрганизацииСтрокой + ", " + ЭлементСписка.Представление;
		КонецЕсли;
	КонецЦикла;
	
	СтрокаОтбора = Результат.Отбор.Добавить();
	СтрокаОтбора.ПолноеИмяМетаданных = "ВсеДокументы";
	СтрокаОтбора.ВыборПериода = ЗначениеЗаполнено(ПериодОтбора);
	СтрокаОтбора.Период       = ПериодОтбора;
	
	КомпоновщикОтбора = Новый КомпоновщикНастроекКомпоновкиДанных;
	СтрокаОтбора.Отбор = КомпоновщикОтбора.Настройки.Отбор;
	
	Если МассивВыбранныхОрганизаций.Количество() > 0 тогда
		ИмяПоляОрганизации = "Ссылка.Организация";
		ИмяПоляТип         = "ОбъектРегистрацииТип";
		ТипЭлементОтбора   = Тип("ЭлементОтбораКомпоновкиДанных");
		
		ОтборПоОрганизации = СтрокаОтбора.Отбор.Элементы.Добавить(ТипЭлементОтбора);
		ОтборПоОрганизации.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(ИмяПоляОрганизации);
		ОтборПоОрганизации.ВидСравнения   = ВидСравненияКомпоновкиДанных.ВСписке;
		ОтборПоОрганизации.ПравоеЗначение = МассивВыбранныхОрганизаций;
		ОтборПоОрганизации.Использование  = Истина;
		
		ОтборПоОрганизацииСтрокой = СокрЛП(Сред(ОтборПоОрганизацииСтрокой, 2));
		
		Результат.Вставить( "ПредставлениеОтбора", 
		                     СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			                 НСтр("ru='Будут отправлены все документы за период: %1 
							|с отбором по организациям: %2'"),
							НРег(Строка(СтрокаОтбора.Период.Вариант)),
							ОтборПоОрганизацииСтрокой
		));
	Иначе
		Результат.Вставить( "ПредставлениеОтбора", 
		                     СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			                 НСтр("ru='Будут отправлены все документы за %1'"),
							НРег(Строка(СтрокаОтбора.Период.Вариант))));
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти