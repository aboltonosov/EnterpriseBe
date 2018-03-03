﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьТаблицуТоваров() Экспорт

	Таблица = Новый ТаблицаЗначений();
	Таблица.Колонки.Добавить("Идентификатор",	Новый ОписаниеТипов("Число"));
	Таблица.Колонки.Добавить("Номенклатура",	Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	Таблица.Колонки.Добавить("Характеристика",	Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	Таблица.Колонки.Добавить("Склад",			Новый ОписаниеТипов("СправочникСсылка.Склады"));
	
	Возврат Таблица;

КонецФункции

Процедура ЗагрузитьДеревоФорматов(Дерево, СхемаОбеспечения, Номенклатура, Характеристика, СкладыДляОбновления, ФорматыДляОбновления) Экспорт
	
	ЭтоОбновление = СкладыДляОбновления <> Неопределено ИЛИ ФорматыДляОбновления <> Неопределено;
	
	Запрос = Новый Запрос();
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЕСТЬNULL(СпрФорматы.ФорматМагазина, ЗНАЧЕНИЕ(Справочник.ФорматыМагазинов.ПустаяСсылка)) КАК Формат,
		|	СпрСклады.Ссылка          КАК Склад,
		|	
		|	ЕСТЬNULL(СпрСпособ.Ссылка, ЗНАЧЕНИЕ(Справочник.СпособыОбеспеченияПотребностей.ПустаяСсылка)) КАК СпособОбеспечения,
		|	
		|	ЕСТЬNULL(СпрСпособ.СрокИсполненияЗаказа, 0)    КАК СрокПоставки,
		|	ЕСТЬNULL(СпрСпособ.ОбеспечиваемыйПериод, 0)    КАК ОбеспечиваемыйПериод,
		|	ЕСТЬNULL(СпрСпособ.ТипОбеспечения, ЗНАЧЕНИЕ(Перечисление.ТипыОбеспечения.ПустаяСсылка)) КАК ТипОбеспечения,
		|	ЕСТЬNULL(СпрСпособ.ИсточникОбеспеченияПотребностей, НЕОПРЕДЕЛЕНО)                  КАК ИсточникОбеспечения,
		|	
		|	ЕСТЬNULL(СпрСпособФормата.Ссылка, ЗНАЧЕНИЕ(Справочник.СпособыОбеспеченияПотребностей.ПустаяСсылка)) КАК СпособОбеспеченияФормата,
		|	
		|	ЕСТЬNULL(СпрСпособФормата.СрокИсполненияЗаказа, 0)   КАК СрокПоставкиФормата,
		|	ЕСТЬNULL(СпрСпособФормата.ОбеспечиваемыйПериод, 0)   КАК ОбеспечиваемыйПериодФормата,
		|	ЕСТЬNULL(СпрСпособФормата.ТипОбеспечения, ЗНАЧЕНИЕ(Перечисление.ТипыОбеспечения.ПустаяСсылка)) КАК ТипОбеспеченияФормата,
		|	ЕСТЬNULL(СпрСпособФормата.ИсточникОбеспеченияПотребностей, НЕОПРЕДЕЛЕНО)                  КАК ИсточникОбеспеченияФормата,
		|
		|	ЕСТЬNULL(ТаблицаУпаковки.УпаковкаЗаказа, ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)) КАК УпаковкаЗаказа,
		|	
		|	НЕ СпрФорматы.ФорматМагазина ЕСТЬ NULL КАК ЕстьФормат,
		|	НЕ &Номенклатура = ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка) КАК ЕстьТовар,
		|	НЕ НастройкаДляТовара.СпособОбеспеченияПотребностей ЕСТЬ NULL ЕстьНастройкаДляТовара,
		|	НЕ НастройкаДляСклада.СпособОбеспеченияПотребностей ЕСТЬ NULL ЕстьНастройкаДляСклада,
		|	НЕ НастройкаДляФормата.СпособОбеспеченияПотребностей ЕСТЬ NULL ЕстьНастройкаДляФормата,
		|	ЕСТЬNULL(НастройкаДляСклада.СпособОбеспеченияПотребностей,
		|		ЕСТЬNULL(НастройкаДляФормата.СпособОбеспеченияПотребностей,
		|			ЗНАЧЕНИЕ(Справочник.СпособыОбеспеченияПотребностей.ПустаяСсылка))) КАК СпособОбеспеченияУнаследованный
		|ИЗ
		|	Справочник.Склады КАК СпрСклады
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсторияИзмененияФорматовМагазинов.СрезПоследних(, ) КАК СпрФорматы
		|		ПО СпрФорматы.Склад = СпрСклады.Ссылка
		|
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВариантыОбеспеченияТоварами КАК НастройкаДляТовара
		|		ПО НастройкаДляТовара.Номенклатура  = &Номенклатура
		|		 И НастройкаДляТовара.Характеристика = &Характеристика
		|		 И НастройкаДляТовара.Склад          = СпрСклады.Ссылка
		|		 И НастройкаДляТовара.РеквизитДопУпорядочивания = 1
		|		
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СхемыОбеспечения КАК НастройкаДляСклада
		|		ПО НастройкаДляСклада.Склад = СпрСклады.Ссылка
		|		 И НастройкаДляСклада.СхемаОбеспечения = &СхемаОбеспечения
		|		
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СхемыОбеспечения КАК НастройкаДляФормата
		|		ПО НастройкаДляФормата.Склад = СпрФорматы.ФорматМагазина
		|		 И НастройкаДляФормата.СхемаОбеспечения = &СхемаОбеспечения
		|		
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СпособыОбеспеченияПотребностей КАК СпрСпособ
		|		ПО СпрСпособ.Ссылка = ЕСТЬNULL(НастройкаДляТовара.СпособОбеспеченияПотребностей, ЕСТЬNULL(НастройкаДляСклада.СпособОбеспеченияПотребностей, НастройкаДляФормата.СпособОбеспеченияПотребностей))
		|		
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СпособыОбеспеченияПотребностей КАК СпрСпособФормата
		|		ПО СпрСпособФормата.Ссылка = НастройкаДляФормата.СпособОбеспеченияПотребностей
		|
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ТоварныеОграничения КАК ТаблицаУпаковки
		|		ПО (ТаблицаУпаковки.Номенклатура = &Номенклатура)
		|		 И (ТаблицаУпаковки.Характеристика = &Характеристика)
		|		 И (ТаблицаУпаковки.Склад = СпрСклады.Ссылка)
		|ГДЕ
		|	НЕ СпрСклады.ЭтоГруппа
		|	И &ОтборПоСкладам
		|	И &ОтборПоФорматам
		|УПОРЯДОЧИТЬ ПО
		|	СпрФорматы.ФорматМагазина,
		|	Склад";
		
	Если ЗначениеЗаполнено(СкладыДляОбновления) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ОтборПоСкладам", "СпрСклады.Ссылка В (&Склады)");
		Запрос.УстановитьПараметр("Склады", СкладыДляОбновления);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ОтборПоСкладам", "Истина");
	КонецЕсли;
	Если ЗначениеЗаполнено(ФорматыДляОбновления) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ОтборПоФорматам", "СпрФорматы.ФорматМагазина В (&Форматы)");
		Запрос.УстановитьПараметр("Форматы", ФорматыДляОбновления);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ОтборПоФорматам", "Истина");
	КонецЕсли;
	
	Запрос.УстановитьПараметр("СхемаОбеспечения",	СхемаОбеспечения);
	Запрос.УстановитьПараметр("Номенклатура",		Номенклатура);
	Запрос.УстановитьПараметр("Характеристика",		Характеристика);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если ЭтоОбновление Тогда
		
		Формат = Неопределено;
		ВетвьФормата = Неопределено;
		
		Корень = Дерево.ПолучитьЭлементы();
		Пока Выборка.Следующий() Цикл
			
			Если Формат <> Выборка.Формат Тогда
				Формат = Выборка.Формат;
				ВетвьФормата = Неопределено;
				Для Каждого ВетвьКорня Из Корень Цикл
					Если Формат = ВетвьКорня.ФорматСклад
						Или (Не ЗначениеЗаполнено(Формат) И Не ЗначениеЗаполнено(ВетвьКорня.ФорматСклад)) Тогда
						ВетвьФормата = ВетвьКорня;
						ВетвьФормата.ТипОбеспечения       = Выборка.ТипОбеспеченияФормата;
						ВетвьФормата.СпособОбеспечения    = Выборка.СпособОбеспеченияФормата;
						ВетвьФормата.СрокПоставки         = Выборка.СрокПоставкиФормата;
						ВетвьФормата.ОбеспечиваемыйПериод = Выборка.ОбеспечиваемыйПериодФормата;
						ВетвьФормата.ИсточникОбеспечения  = Выборка.ИсточникОбеспеченияФормата;
						Прервать;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			
			Если ВетвьФормата <> Неопределено Тогда
				УзлыВетви = ВетвьФормата.ПолучитьЭлементы();
				Для Каждого Узел Из УзлыВетви Цикл
					Если Узел.ФорматСклад = Выборка.Склад Тогда
						ЗаполнитьЗначенияСвойств(Узел, Выборка);
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			
		КонецЦикла;
	Иначе
		Дерево.ПолучитьЭлементы().Очистить();
		
		Корень = Дерево.ПолучитьЭлементы();
		Формат = Неопределено;
		Пока Выборка.Следующий() Цикл
			
			Если Формат <> Выборка.Формат Тогда
				
				Формат = Выборка.Формат;
				
				УзелКорня = Корень.Добавить();
				УзелКорня.СтандартнаяКартинка = 1;
				
				УзелКорня.ФорматСклад          = Выборка.Формат;
				УзелКорня.ЭтоФормат            = Истина;
				УзелКорня.ТипОбеспечения       = Выборка.ТипОбеспеченияФормата;
				УзелКорня.СпособОбеспечения    = Выборка.СпособОбеспеченияФормата;
				УзелКорня.СрокПоставки         = Выборка.СрокПоставкиФормата;
				УзелКорня.ОбеспечиваемыйПериод = Выборка.ОбеспечиваемыйПериодФормата;
				УзелКорня.ИсточникОбеспечения  = Выборка.ИсточникОбеспеченияФормата;
				
				Ветвь = УзелКорня.ПолучитьЭлементы();
				
			КонецЕсли;
			
			Узел = Ветвь.Добавить();
			Узел.ФорматСклад = Выборка.Склад;
			Узел.ЭтоФормат = Ложь;
			ЗаполнитьЗначенияСвойств(Узел, Выборка);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Процедура ВключитьОтборПоИзменениюАссортимента(ОбъектНастройки) Экспорт
	
	ПараметрИспользуетсяОтбор = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(
		ОбъектНастройки.Настройки, 
		"ИспользуетсяОтборАссортимента");
	
	ПараметрИспользуетсяОтбор.Значение      = Ложь;
	ПараметрИспользуетсяОтбор.Использование = Ложь;
	
	НастройкиОсновнойСхемы = ОбъектНастройки.ПолучитьНастройки();
	
	ЭлементыОтбора = ОбщегоНазначенияКлиентСервер.НайтиЭлементыИГруппыОтбора(НастройкиОсновнойСхемы.Отбор, "ДокументИзмененияАссортимента");
	ИспользуетсяОтбор = Ложь;
	
	Для каждого ЭлементОтбора из ЭлементыОтбора Цикл
		Если ЭлементОтбора.Использование Тогда
			ИспользуетсяОтбор = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(ОбъектНастройки, "ИспользуетсяОтборАссортимента", Истина, ИспользуетсяОтбор);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли