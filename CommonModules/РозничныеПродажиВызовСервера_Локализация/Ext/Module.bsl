﻿
#Область ПрограммныйИнтерфейс

//Условное оформление для функционала, связанного с розницей
// 
// Параметры:
//  Форма - Форма - Содержит данную форму
//  ИмяДокумента  - Строка - имя документа.
//
Процедура УстановитьНастройкиВидимостиРеквизитовКомандДляРозницы(Форма, ИмяДокумента)Экспорт
	
	Если ИмяДокумента = "Поступление" Тогда
		Если  Форма.Элементы.Найти("ТоварыЦенаИзготовителя")  = Неопределено Тогда
			Возврат;
		КонецЕсли;
	Иначе
		Если  Форма.Элементы.Найти("ТоварыЦена")  = Неопределено Тогда
			Возврат;
		КонецЕсли;
	Конецесли;
	
	УсловноеОформление = Форма.УсловноеОформление;
	ЭлементыФормы = Форма.Элементы;
	Команды = Форма.Команды;
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	Если ИмяДокумента = "Поступление" Тогда
		ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ЭлементыФормы["ТоварыЦенаИзготовителя"].Имя);
	Иначе
		ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ЭлементыФормы["ТоварыЦена"].Имя);
    КонецЕсли;	
		
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ЭлементыФормы["ТоварыСтавкаТН"].Имя);
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ЭлементыФормы["ГруппаСтавки"].Имя);

	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ЭлементыФормы["ТоварыСуммаТН"].Имя);

	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ЭлементыФормы["ТоварыРозничнаяЦенаБезНДС"].Имя);

	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ЭлементыФормы["ТоварыРозничнаяСтавкаНДС"].Имя);

	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ЭлементыФормы["ТоварыРозничнаяСуммаНДС"].Имя);

	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ЭлементыФормы["ТоварыРозничнаяЦена"].Имя);

	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ЭлементыФормы["ТоварыОкругление"].Имя);

	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ЭлементыФормы["ТоварыРозничнаяЦенаСУчетомОкругления"].Имя);

	ГруппаОтбора1 = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора1.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаНе;
	
	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЭтоРозничныйСклад");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение =  Истина;
	
	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("РассчитыватьРеквизитыРозницы");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение =  Истина;

	Если ИмяДокумента = "Поступление" Тогда
		ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ХозяйственнаяОперация");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
		СписокОпераций = Новый СписокЗначений;
		СписокОпераций.Добавить(Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщика);
		СписокОпераций.Добавить(Перечисления.ХозяйственныеОперации.ЗакупкаЧерезПодотчетноеЛицо);
		ОтборЭлемента.ПравоеЗначение = СписокОпераций;
	КонецЕсли;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
КонецПроцедуры // ()

#Область ПроцедурыИФункцииПроверкиКорректностиЗаполненияДокументов

// Проверяет корректность заполнения документа установки цен номенклатуры
// Вызывается из процедуры документа "ОбработкаПроведения"
//
// Параметры:
//  ДокументТорговаяНадбавка - ДокументОбъект, для которого необходимо осуществить проверки
//  Отказ                    - Булево - Флаг отказа от проведения документа.
//
Процедура ПроверитьКорректностьЗаполненияДокументаТорговаяНадбавка(ДокументТорговаяНадбавка, Отказ) Экспорт
	
	ТекстЗапроса     = "";
	ПараметрыЗапроса = Новый Структура();
	
	МассивПроверок    = Новый Массив();
	МассивПроверок.Добавить("ВременнаяТаблицаТовары");
	МассивПроверок.Добавить("КорректностьТоваров");
	МассивПроверок.Добавить("НаличиеУслуг");
	
	// Сформируем текст запроса необходимых проверок в соответствие с массивом проверок
	
	Для Каждого ТекЭлемент Из МассивПроверок Цикл

		Если ТекЭлемент = "ВременнаяТаблицаТовары" Тогда
			
			СформироватьЗапросВременнаяТаблицаРегистрацияТорговыхНадбавок(ТекстЗапроса,ПараметрыЗапроса,ДокументТорговаяНадбавка);
			
		ИначеЕсли ТекЭлемент = "КорректностьТоваров" Тогда
			
			СформироватьЗапросКорректностьТоваровДляРегистрацияТорговыхНадбавок(ТекстЗапроса);
					
		ИначеЕсли ТекЭлемент = "НаличиеУслуг" Тогда
			
			СформироватьЗапросНаличиеУслугДляРегистрацияТорговыхНадбавок(ТекстЗапроса);
			
		КонецЕсли;
			
	КонецЦикла;
	
	Запрос = Новый Запрос(ТекстЗапроса);
	
	Для Каждого ПараметрЗапроса Из ПараметрыЗапроса Цикл
		Запрос.УстановитьПараметр(ПараметрЗапроса.Ключ,ПараметрЗапроса.Значение);
	КонецЦикла;
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	// Сообщим пользователю о результатах проверки для каждого результата запроса
	
	Для ТекИндекс = 0 По МассивРезультатов.Количество()-1 Цикл
	
		Выборка = МассивРезультатов[ТекИндекс].Выбрать();
		
		Если МассивПроверок[ТекИндекс] = "КорректностьТоваров" Тогда
			
			СообщитьОбОшибкахКорректностьТоваровДляРегистрацияТорговыхНадбавок(Выборка, ДокументТорговаяНадбавка, Отказ);
						
		ИначеЕсли МассивПроверок[ТекИндекс] = "НаличиеУслуг" Тогда
			
			СообщитьОбОшибкахНаличиеУслугДляРегистрацияТорговыхНадбавок(Выборка, ДокументТорговаяНадбавка, Отказ);
			
		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры // ПроверитьКорректностьЗаполненияДокументаУстановкиЦенНоменклатурыПоставщика()

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПроцедурыФормированияЗапросовПроверкиТорговаяНадбавка
// Формирует запрос для формирования временной таблицы цен
//
// Параметры:
// ТекстЗапроса          - Строка - текстовая строка, к которой необходимо добавить текст запроса
// ПараметрыЗапроса      - Структура - структура, содержащая параметры запроса
// ДокументУстановкиЦен  - ДокументОбъект.УстановкаЦенНоменклатуры - документ, к которому необходимость сформировать запрос
//
Процедура СформироватьЗапросВременнаяТаблицаРегистрацияТорговыхНадбавок(ТекстЗапроса, ПараметрыЗапроса,ДокументТорговаяНадбавка) 	
	ТекстЗапроса = ТекстЗапроса + "ВЫБРАТЬ
	                              |	ВременнаяТаблицаТовары.НомерСтроки КАК НомерСтроки,
	                              |	ВременнаяТаблицаТовары.Номенклатура КАК Номенклатура,
	                              |	ВременнаяТаблицаТовары.Характеристика КАК Характеристика,
	                              |	ВременнаяТаблицаТовары.Склад
	                              |ПОМЕСТИТЬ ВременнаяТаблицаТовары
	                              |ИЗ
	                              |	&Товары КАК ВременнаяТаблицаТовары
								  |;
								  |";
		
		ПараметрыЗапроса.Вставить("Товары", ДокументТорговаяНадбавка.Товары.Выгрузить(, "НомерСтроки,Номенклатура,Характеристика,Склад"));
	
КонецПроцедуры // СформироватьЗапросВременнаяТаблицаТорговойНадбавки()

// Формирует запрос для проверки корректности заполнения тч Товары документа Торговая надбавка
//
//
// Параметры:
// ТекстЗапроса - Строка - текстовая строка, к которой необходимо добавить текст запроса
//
Процедура СформироватьЗапросКорректностьТоваровДляРегистрацияТорговыхНадбавок(ТекстЗапроса)
	
	ТекстЗапроса = ТекстЗапроса + "ВЫБРАТЬ
	                              |	МАКСИМУМ(ДокументТовары.НомерСтроки) КАК НомерСтроки,
	                              |	ДокументТовары.Номенклатура КАК Номенклатура,
	                              |	ДокументТовары.Характеристика КАК Характеристика,
	                              |	ДокументТовары.Склад
	                              |ИЗ
	                              |	ВременнаяТаблицаТовары КАК ДокументТовары
	                              |ГДЕ
	                              |	ДокументТовары.Номенклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	                              |
	                              |СГРУППИРОВАТЬ ПО
	                              |	ДокументТовары.Номенклатура,
	                              |	ДокументТовары.Характеристика,
	                              |	ДокументТовары.Склад
	                              |
	                              |ИМЕЮЩИЕ
	                              |	КОЛИЧЕСТВО (*) > 1
								  |;
								  |";
	
КонецПроцедуры // СформироватьЗапросКорректностьТоваровДляТорговойНадбавки()

// Формирует текст запроса для проверки наличия услуг в документе ТОрговая надбавка
//
// Параметры:
// ТекстЗапроса          - Строка - текстовая строка, к которой необходимо добавить текст запроса
//
Процедура СформироватьЗапросНаличиеУслугДляРегистрацияТорговыхНадбавок(ТекстЗапроса)
	
	ТекстЗапроса = ТекстЗапроса + "
		|ВЫБРАТЬ
		|	ДокументТовары.НомерСтроки  КАК НомерСтроки,
		|	ДокументТовары.Номенклатура КАК Номенклатура
		|ИЗ
		|	ВременнаяТаблицаТовары КАК ДокументТовары
		|ГДЕ
		|	ДокументТовары.Номенклатура.ТипНоменклатуры НЕ В
		|		(ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар),ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара))
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки ВОЗР
		|;
		|";
	
КонецПроцедуры // СформироватьЗапросНаличиеУслугДляТорговаяНадбавка()

Процедура ОтразитьТорговыеНадбавки(ДополнительныеСвойства,
	                                         Движения,
	                                         Отказ) Экспорт
	
	Таблица = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаТорговыеНадбавки;
	
	Если Отказ Или Таблица.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТорговыеНадбавки            = Движения.ТорговыеНадбавки;
	ТорговыеНадбавки.Записывать = Истина;
	ТорговыеНадбавки.Загрузить(Таблица);
	
КонецПроцедуры
#КонецОбласти

#Область ПроцедурыДляВыводаСообщенийОбОшибкахТорговаяНадбавка

Процедура СообщитьПользователюОбОшибкеДляРегистрацияТорговыхНадбавок(ТекстОшибки, ДокументУстановкиЦен, НомерСтроки, Поле, Отказ)
	
	Если Найти(Строка(ДокументУстановкиЦен.Метаданные().ПолноеИмя()), "Обработка.") <> 0 Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			,
			"Объект." + ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", НомерСтроки, Поле),
			,
			Отказ);
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			ДокументУстановкиЦен,
			ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", НомерСтроки, Поле),
			,
			Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

// Выводит сообщения об ошибках наличия услуг в документа УстановкаЦенНоменклатурыПоставщика
//
// Параметры:
// Выборка               - ВыборкаИзРезультатаЗапроса
// ДокументТорговаяНадбавка  - ДокументОбъект.ТорговаяНадбавка - документ, для которого необходимо вывести сообщения об ошибках
// Отказ                 - Булево - Флаг отказа от проведения документа
//
Процедура СообщитьОбОшибкахНаличиеУслугДляРегистрацияТорговыхНадбавок(Выборка,
	                                                               ДокументТорговойНадбавки,
	                                                               Отказ)
	
	Пока Выборка.Следующий() Цикл
		
		ТекстОшибки = НСтр("ru='В документе нельзя указывать номенклатуру с типом ""Услуга"" (строка %НомерСтроки% списка ""Товары"")'");
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%Номенклатура%", Выборка.Номенклатура);
		ТекстОшибки = СтрЗаменить(ТекстОшибки, "%НомерСтроки%",  Выборка.НомерСтроки);
		
		СообщитьПользователюОбОшибкеДляРегистрацияТорговыхНадбавок(ТекстОшибки, ДокументТорговойНадбавки, Выборка.НомерСтроки, "Номенклатура", Отказ);
		
	КонецЦикла;
	
КонецПроцедуры // СообщитьОбОшибкахНаличиеУслугДляТорговойНадбавки()

// Выводит сообщения об ошибках в тч Товары документа УстановкаЦенНоменклатуры
//
// Параметры:
// Выборка               - ВыборкаИзРезультатаЗапроса
// ДокументРегистрацияТорговойНадбавки  - ДокументОбъект.РегистрацияТорговыхНадбавок - документ, для которого необходимо вывести сообщения об ошибках
// Отказ                 - Булево - флаг отказа от проведения документа
//
Процедура СообщитьОбОшибкахКорректностьТоваровДляРегистрацияТорговыхНадбавок(Выборка,
	                                                            ДокументРегистрацияТорговойНадбавки,
	                                                            Отказ)
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.ЕстьОшибкиЗаполненияНоменклатуры Тогда
			
			ТекстОшибки = НСтр("ru='Не заполнена колонка ""Номенклатура"" в строке ""%НомерСтроки%"" списка ""Товары""'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%НомерСтроки%", Выборка.НомерСтроки);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ДокументРегистрацияТорговойНадбавки.Ссылка,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", Выборка.НомерСтроки, "Номенклатура"),
				,
				Отказ);
			
			КонецЕсли;
			
		Если Выборка.ЕстьОшибкиЗаполненияХарактеристики Тогда
			
			ТекстОшибки = НСтр("ru='Не заполнена колонка ""Характеристика"" в строке ""%НомерСтроки%"" списка ""Товары""'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки, "%НомерСтроки%", Выборка.НомерСтроки);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				ДокументРегистрацияТорговойНадбавки.Ссылка,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Товары", Выборка.НомерСтроки, "Характеристика"),
				,
				Отказ);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры // СообщитьОбОшибкахКорректностьТоваровДляРегистрацияТорговыхНадбавок()

#КонецОбласти

#Область ЗаполнениеРозничныхСтавокВТаблице

// Заполняет розничные ставки
Процедура ЗаполнитьРозничныеСтавкиВТабличнойЧасти(ТабличнаяЧасть, Склад, Дата,  СтруктураДействий = Неопределено) Экспорт
	
	Перем СтруктураЦены;

	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ
	                      |	ТабличнаяЧасть.НомерСтроки КАК НомерСтроки,
	                      |	ТабличнаяЧасть.Номенклатура КАК Номенклатура,
	                      |	ТабличнаяЧасть.Характеристика КАК Характеристика
	                      |ПОМЕСТИТЬ ТабличнаяЧасть
	                      |ИЗ
	                      |	&ТабличнаяЧасть КАК ТабличнаяЧасть
	                      |ГДЕ
	                      |	ТабличнаяЧасть.Номенклатура <> ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ТабличнаяЧасть.НомерСтроки КАК НомерСтроки,
	                      |	СрезПоследнихТорговаяНадбавка.Надбавка КАК СтавкаТН
	                      |ИЗ
	                      |	ТабличнаяЧасть КАК ТабличнаяЧасть
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ТорговыеНадбавки.СрезПоследних(
	                      |				&Дата,
	                      |				(Номенклатура, Склад, Характеристика) В
	                      |					(ВЫБРАТЬ
	                      |						ТабличнаяЧасть.Номенклатура,
	                      |						&Склад,
	                      |						ТабличнаяЧасть.Характеристика
	                      |					ИЗ
	                      |						ТабличнаяЧасть КАК ТабличнаяЧасть)) КАК СрезПоследнихТорговаяНадбавка
	                      |		ПО ТабличнаяЧасть.Номенклатура = СрезПоследнихТорговаяНадбавка.Номенклатура
	                      |			И ТабличнаяЧасть.Характеристика = СрезПоследнихТорговаяНадбавка.Характеристика
	                      |
	                      |УПОРЯДОЧИТЬ ПО
	                      |	НомерСтроки");
		
	Запрос.УстановитьПараметр("ТабличнаяЧасть", ТабличнаяЧасть.Выгрузить(,"НомерСтроки,Номенклатура,Характеристика"));
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("Дата", Дата);

	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	Если Не РезультатЗапроса[1].Пустой() Тогда
		
		Выборка = РезультатЗапроса[1].Выбрать();
		
		Для Каждого ТекСтрока Из ТабличнаяЧасть Цикл
			
			Если Выборка.НайтиСледующий(ТекСтрока.НомерСтроки, "НомерСтроки") Тогда
				
				ТекСтрока.СтавкаТН = Выборка.СтавкаТН;
				
				
				Если СтруктураДействий <> Неопределено Тогда
					
					Если СтруктураДействий.Свойство("ЗаполнитьРозничнуюСтавкуНДС") Тогда
						РозничныеПродажи_Локализация.ЗаполнитьРозничнуюСтавкуНДСВСтрокеТЧ(ТекСтрока, СтруктураДействий);
					КонецЕсли;	
					
					Если СтруктураДействий.Свойство("ЗаполнитьЦену", СтруктураЦены) Тогда
						
						СтруктураЦены.Вставить("Номенклатура", ТекСтрока.Номенклатура);
						СтруктураЦены.Вставить("Характеристика", ТекСтрока.Характеристика);
						СтруктураЦены.Вставить("Упаковка", ТекСтрока.Упаковка);
						
						ТекСтрока.Цена = ПродажиСервер.ПолучитьЦенуПоОтбору(СтруктураЦены);
						
					КонецЕсли;
					
					
					Если СтруктураДействий.Свойство("РассчитатьРозничнуюЦену") Тогда
						РассчитатьРозничнуюЦенуВСтрокеТЧ(ТекСтрока, СтруктураДействий);
					КонецЕсли;
					
				КонецЕсли;
				
				Выборка.Сбросить();
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура назначает торговые надбавки в табличной части
//
Процедура НазначитьРозничныеСтавки(Объект, ИмяТЧ, СтавкаТН, ИмяКолонкиСтавкаТН, ИмяДокумента, ВидЦен, ВыделенныеСтроки = Неопределено, ТолькоДляАктивныхСтрок = Ложь) Экспорт
		
	Если ВыделенныеСтроки <> Неопределено Тогда
		СтрокиТабличнойЧасти = Новый Массив();
		
		Для Каждого ТекСтрока Из ВыделенныеСтроки Цикл
			НайденнаяСтрока = Объект[ИмяТЧ].НайтиПоИдентификатору(ТекСтрока);
			СтрокиТабличнойЧасти.Добавить(НайденнаяСтрока);
		КонецЦикла;
		
	Иначе
		Если ТолькоДляАктивныхСтрок Тогда
			СтрокиТабличнойЧасти = Объект[ИмяТЧ].НайтиСтроки(Новый Структура("Активность", Истина));
		Иначе
			СтрокиТабличнойЧасти = Объект[ИмяТЧ];
		КонецЕсли;
	КонецЕсли;
	
	Для каждого ТекущаяСтрока Из СтрокиТабличнойЧасти Цикл
		ТекущаяСтрока[ИмяКолонкиСтавкаТН] =  СтавкаТН;
		
		Если ИмяДокумента = "Поступление" 
			ИЛИ ИмяДокумента = "Перемещение" Тогда
			
			СтруктураПараметров = Новый Структура("ИмяДокумента, ЦенаВключаетНДС, ВидЦен", ИмяДокумента, ?(ИмяДокумента = "Поступление", 
				Объект.ЦенаВключаетНДС, Ложь), ВидЦен);
			СтруктураДействий = Новый Структура;
			СтруктураДействий.Вставить("РассчитатьРозничнуюЦену", СтруктураПараметров);
			
			РассчитатьРозничнуюЦенуВСтрокеТЧ(ТекущаяСтрока, СтруктураДействий);
		КонецЕсли;	
	КонецЦикла;	
	
КонецПроцедуры

#КонецОбласти

#Область РозничныеСтавкиЦеныВСтрокеТЧ

Процедура ЗаполнитьСтавкуТорговойНадбавкиВСтрокеТЧ(ТекущаяСтрока, ПараметрСтруктурыДействий)Экспорт 
	
	Перем ПараметрыСтавкиТН;
	Если ПараметрСтруктурыДействий.Свойство("ЗаполнитьСтавкуТорговойНадбавки",ПараметрыСтавкиТН) Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТорговыеНадбавкиСрезПоследних.Надбавка КАК СтавкаТорговойНадбавки
		|ИЗ
		|	РегистрСведений.ТорговыеНадбавки.СрезПоследних(
		|			КОНЕЦПЕРИОДА(&Дата, ДЕНЬ),
		|			Номенклатура = &Номенклатура
		|				И Склад = &Склад
		|				И Характеристика = &Характеристика) КАК ТорговыеНадбавкиСрезПоследних";
		
		Запрос.УстановитьПараметр("Дата", ПараметрыСтавкиТН.Дата);
		Запрос.УстановитьПараметр("Номенклатура", ТекущаяСтрока.Номенклатура);
		Запрос.УстановитьПараметр("Склад", ПараметрыСтавкиТН.Склад);
		Запрос.УстановитьПараметр("Характеристика", ТекущаяСтрока.Характеристика);
		
		РезультатЗапроса = Запрос.Выполнить();
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();

		Если  ВыборкаДетальныеЗаписи.Следующий() ТОгда
			 ТекущаяСтрока.СтавкаТН = ВыборкаДетальныеЗаписи.СтавкаТорговойНадбавки;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ЗаполнитьРозничнуюСтавкуНДСВСтрокеТЧ(ТекущаяСтрока, СтруктураДействий) Экспорт
	
	Если  СтруктураДействий.Свойство("ЗаполнитьРозничнуюСтавкуНДС") Тогда
		 ТекущаяСтрока.РозничнаяСтавкаНДС = Справочники.Номенклатура.ЗначенияРеквизитовНоменклатуры(ТекущаяСтрока.Номенклатура).РозничнаяСтавкаНДС;
	КонецЕсли;
	
КонецПроцедуры

Процедура РассчитатьРозничнуюЦенуВСтрокеТЧ(ТекущаяСтрока, СтруктураДействий)Экспорт
	
	Перем  ЦенаВключаетНДС;
	Перем  Параметры;
	Перем  ВидЦен;
	
	Если СтруктураДействий.Свойство("РассчитатьРозничнуюЦену", Параметры) Тогда
		
		Если Параметры = Неопределено Тогда
			Возврат;
		КонецЕсли;	
		
		Если НЕ Параметры.Свойство("ЦенаВключаетНДС", ЦенаВключаетНДС)  Тогда
			ЦенаВключаетНДС = Ложь;
		КонецЕсли;
		
		//поступление товаров услуг	
		РасчетнаяЦена = ПолучитьРасчетнуюЦенуДляТорговойНадбавки(ТекущаяСтрока, Параметры.ИмяДокумента, ЦенаВключаетНДС);
		ТекущаяСтрока.СуммаТН =  РасчетнаяЦена * ТекущаяСтрока.СтавкаТН/100;
		СтавкаЧислом = ЦенообразованиеКлиентСервер.ПолучитьСтавкуНДСЧислом(ТекущаяСтрока.РозничнаяСтавкаНДС);
		ТекущаяСтрока.РозничнаяСуммаНДС = (РасчетнаяЦена+ТекущаяСтрока.СуммаТН)*СтавкаЧислом;
		ТекущаяСтрока.РозничнаяЦенаБезНДС =  РасчетнаяЦена +ТекущаяСтрока.СуммаТН ; 
		ТекущаяСтрока.РозничнаяЦена =  РасчетнаяЦена + ТекущаяСтрока.СуммаТН + ТекущаяСтрока.РозничнаяСуммаНДС;
		ТекущаяСтрока.РозничнаяЦенаСУчетомОкругления = ТекущаяСтрока.РозничнаяЦена;
		
		Если НЕ Параметры.Свойство("ВидЦен") ИЛИ Не ЗначениеЗаполнено(Параметры.ВидЦен) Тогда 
			ТекущаяСтрока.РозничнаяЦенаСУчетомОкругления = Окр(ТекущаяСтрока.РозничнаяЦена, 2);
		Иначе
			ТекущаяСтрока.РозничнаяЦенаСУчетомОкругления = ОкруглитьЦенуПоПравиламЦенообразования(ТекущаяСтрока.РозничнаяЦенаСУчетомОкругления, Параметры.ВидЦен);
		КонецЕсли;

		ТекущаяСтрока.Округление = ТекущаяСтрока.РозничнаяЦенаСУчетомОкругления -  ТекущаяСтрока.РозничнаяЦена;
		
	КонецЕсли;	
	
КонецПроцедуры

Процедура РассчитатьСтавкуСуммуТорговойНадбавкиВСтрокеТЧ(ТекущаяСтрока, СтруктураДействий) Экспорт
	
	Перем  ЦенаВключаетНДС;
	Перем  Параметры;
	
	Если СтруктураДействий.Свойство("РассчитатьСтавкуСуммуТорговойНадбавки", Параметры) Тогда
		
		Если Параметры = Неопределено Тогда
			Возврат;
		КонецЕсли;	
		
		Если НЕ Параметры.Свойство("ЦенаВключаетНДС", ЦенаВключаетНДС)  Тогда
			ЦенаВключаетНДС = Ложь;
		КонецЕсли;

		РасчетнаяЦена = ПолучитьРасчетнуюЦенуДляТорговойНадбавки(ТекущаяСтрока, Параметры.ИмяДокумента, ЦенаВключаетНДС);
		СтавкаЧислом = ЦенообразованиеКлиентСервер.ПолучитьСтавкуНДСЧислом(ТекущаяСтрока.РозничнаяСтавкаНДС);
		ТекущаяСтрока.РозничнаяСуммаНДС =  ТекущаяСтрока.РозничнаяЦенаСУчетомОкругления*СтавкаЧислом/(1+СтавкаЧислом);
		ТекущаяСтрока.СуммаТН =  ТекущаяСтрока.РозничнаяЦенаСУчетомОкругления- ТекущаяСтрока.РозничнаяСуммаНДС-РасчетнаяЦена;
		ТекущаяСтрока.СтавкаТН =  ТекущаяСтрока.СуммаТН*100/РасчетнаяЦена;
		
		ТекущаяСтрока.Округление = 0;
		ТекущаяСтрока.РозничнаяЦена = 0;
		ТекущаяСтрока.РозничнаяЦенаБезНДС = ТекущаяСтрока.РозничнаяЦенаСУчетомОкругления - ТекущаяСтрока.РозничнаяСуммаНДС;

	КонецЕсли;

КонецПроцедуры

Функция ПолучитьРасчетнуюЦенуДляТорговойНадбавки(ТекущаяСтрока, ИмяДокумента, ЦенаВключаетНДС)Экспорт
	
	РасчетнаяЦена = 0;	
	
	Если ИмяДокумента = "Поступление" ТОгда 
		Если  ТекущаяСтрока.ЦенаСоСкидкой  = 0 Тогда
			Если  ЦенаВключаетНДС Тогда
				РасчетнаяЦена = (ТекущаяСтрока.Сумма - ТекущаяСтрока.СуммаНДС)/ТекущаяСтрока.КоличествоУпаковок;
			Иначе
				РасчетнаяЦена =  ТекущаяСтрока.Цена;
			КонецЕсли;	
		Иначе
			Если ТекущаяСтрока.ЦенаИзготовителя = 0 ИЛИ ТекущаяСтрока.ЦенаИзготовителя = ТекущаяСтрока.Цена Тогда
				РасчетнаяЦена = ТекущаяСтрока.ЦенаСоСкидкой;
			Иначе
				РасчетнаяЦена = ТекущаяСтрока.ЦенаИзготовителя;
			КонецЕсли;	 
		КонецЕсли;
	Иначе
		РасчетнаяЦена = ТекущаяСтрока.Цена
	КонецЕсли;	
	
	Возврат РасчетнаяЦена;
	
КонецФункции

Процедура ЗаполнитьЦенуИзЦеныИзготовителяВСтрокеТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения) Экспорт
	
	Если  СтруктураДействий.Свойство("ЗаполнитьЦенуИзЦеныИзготовителя")  Тогда
		 ТекущаяСтрока.Цена = ТекущаяСтрока.ЦенаИзготовителя;
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьИспользованиеТорговыхНадбавок() Экспорт

	Если НЕ Константы.ИспользоватьРозничныеПродажи.Получить() Тогда
	
		Константы.ИспользоватьТорговыеНадбавки.Установить(Ложь);	
	
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#КонецОбласти



&НаСервере
Процедура НазначитьСтавкуТорговойНадбавкиНаСервере(Объект, ЭтаФорма, СтавкаТорговойНадбавки, Знач ВыделенныеСтроки = Неопределено) Экспорт

	РозничныеПродажи_Локализация.НазначитьРозничныеСтавки(Объект, "Товары", СтавкаТорговойНадбавки, "СтавкаТН", "Перемещение", ЭтаФорма["РозничныйВидЦен"], ВыделенныеСтроки);
		
КонецПроцедуры


Функция ПолучитьВалютуЦены(ВидЦены) Экспорт

	Возврат ВидЦены.ВалютаЦены;	

КонецФункции // ()


Процедура ВставитьРеквизитВТабличнуюЧасть(Форма, Элементы, ИмяТабЧасти, ИмяЭлемента, Заголовок, Подсказка) Экспорт

	Если  Элементы.Найти(ИмяТабЧасти + ИмяЭлемента) = Неопределено Тогда
		Элемент = Элементы.Вставить(ИмяТабЧасти + ИмяЭлемента, Тип("ПолеФормы"), Элементы[ИмяТабЧасти]);
		Элемент.ПутьКДанным = "Объект." + ИмяТабЧасти  + "."+ ИмяЭлемента;
		Элемент.Вид = ВидПоляФормы.ПолеВвода;
		Элемент.Заголовок = Заголовок;
		Элемент.Подсказка = Подсказка;
	КонецЕсли;

КонецПроцедуры

Процедура ДобавитьЭлементРозничнаяСтавкаНДС(Элементы, ГруппаРодитель, ИмяЭлементПосл) Экспорт
	
	Элемент = Элементы.Вставить("РозничнаяСтавкаНДС", Тип("ПолеФормы"), ГруппаРодитель, Элементы[ИмяЭлементПосл]);
	Элемент.ПутьКДанным = "Объект.РозничнаяСтавкаНДС";
	Элемент.Вид = ВидПоляФормы.ПолеВвода;
	Элемент.Заголовок = "Розничная ставка НДС";
	Элемент.Ширина = 9;
	Элемент.РастягиватьПоГоризонтали = Ложь;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьРозничныеПродажи") 
		И  ПолучитьФункциональнуюОпцию("ИспользоватьТорговыеНадбавки")Тогда
		Элементы.РозничнаяСтавкаНДС.Видимость = Истина;
	Иначе
		Элементы.РозничнаяСтавкаНДС.Видимость = ЛОжь;
	КонецЕсли;
	
КонецПроцедуры	

Процедура ДобавитьРеквизитЭтоРозничныйСклад(Форма) Экспорт
    
	Если НЕ ЕстьРеквизитФормы(Форма,"ЭтоРозничныйСклад") Тогда
		МассивДобавляемыхРеквизитов = Новый Массив;
		МассивДобавляемыхРеквизитов.Добавить(Новый РеквизитФормы("ЭтоРозничныйСклад", Новый ОписаниеТипов("Булево")));
		Форма.ИзменитьРеквизиты(МассивДобавляемыхРеквизитов, );		
	КонецЕсли;

КонецПроцедуры

Процедура ДобавитьРеквизитРассчитыватьРеквизитыРозницы(Форма) Экспорт

	Если НЕ ЕстьРеквизитФормы(Форма,"РассчитыватьРеквизитыРозницы") Тогда
		МассивДобавляемыхРеквизитов = Новый Массив;
		МассивДобавляемыхРеквизитов.Добавить(Новый РеквизитФормы("РассчитыватьРеквизитыРозницы", Новый ОписаниеТипов("Булево")))	;
		Форма.ИзменитьРеквизиты(МассивДобавляемыхРеквизитов, );	
	КонецЕсли;

КонецПроцедуры

Процедура ДобавитьРеквизитРозничныйВидЦен(Форма) Экспорт

	Если НЕ ЕстьРеквизитФормы(Форма,"РозничныйВидЦен") Тогда
		МассивДобавляемыхРеквизитов = Новый Массив;
		МассивДобавляемыхРеквизитов.Добавить(Новый РеквизитФормы("РозничныйВидЦен", Новый ОписаниеТипов("СправочникСсылка.ВидыЦен")))	;
		Форма.ИзменитьРеквизиты(МассивДобавляемыхРеквизитов, );	
	КонецЕсли;

КонецПроцедуры

Процедура ДополнитьРеквизитыРозницы(Форма) Экспорт
	
	Элементы = Форма.Элементы;
	Команды = Форма.Команды;
		
	ВставитьРеквизитВТабличнуюЧасть(Форма, Элементы, "Товары", "СтавкаТН",  "Ставка ТН, ", "Процент торговой надбавки");
	ВставитьРеквизитВТабличнуюЧасть(Форма, Элементы, "Товары", "СуммаТН", "Сумма ТН", "Сумма торговой надбавки");
	ВставитьРеквизитВТабличнуюЧасть(Форма, Элементы, "Товары", "РозничнаяЦенаБезНДС", "Розничная цена без НДС", "Розничная цена без НДС");
	ВставитьРеквизитВТабличнуюЧасть(Форма, Элементы, "Товары", "РозничнаяСтавкаНДС", "Розничная ставка НДС", "Розничная ставка НДС");
	ВставитьРеквизитВТабличнуюЧасть(Форма, Элементы, "Товары", "РозничнаяСуммаНДС", "Розничная сумма НДС", "Розничная сумма НДС");
	ВставитьРеквизитВТабличнуюЧасть(Форма, Элементы, "Товары", "РозничнаяЦенаСУчетомОкругления", "Розничная цена", "Розничная цена");
	ВставитьРеквизитВТабличнуюЧасть(Форма, Элементы, "Товары", "Округление", "Округление", "Округление");
	ВставитьРеквизитВТабличнуюЧасть(Форма, Элементы, "Товары", "РозничнаяЦена", "Розничная цена (без окр.)", "Розничная цена (без округления)");
			
	Элементы["ТоварыРозничнаяЦенаСУчетомОкругления"].УстановитьДействие("ПриИзменении", "Подключаемый_ТоварыРозничнаяЦенаСУчетомОкругленияПриИзменении");
	Элементы["ТоварыСтавкаТН"].УстановитьДействие("ПриИзменении", "Подключаемый_ТоварыСтавкаТНПриИзменении");
	Элементы["ТоварыРозничнаяСтавкаНДС"].УстановитьДействие("ПриИзменении", "Подключаемый_ТоварыРозничнаяСтавкаНДСПриИзменении");

	
	Если Команды.Найти("ЗаполнитьСтавкуТН") = Неопределено Тогда
		
		ГруппаСтавки = Элементы.Вставить("ГруппаСтавки", Тип("ГруппаФормы"),  
					?(Элементы.Найти("ТоварыГруппаЗаполнить") <> Неопределено, Элементы.ТоварыГруппаЗаполнить,Элементы.ТоварыЗаполнить), Элементы.ТоварыДополнитьМногооборотнойТарой);
		
		ГруппаСтавки.вид = ВидГруппыФормы.Подменю;
		ГруппаСтавки.Заголовок = "Розничные ставки";
		
		//ТН
		ГруппаТН = Элементы.Добавить("ГруппаТН", Тип("ГруппаФормы"),  ГруппаСтавки);
		ГруппаТН.вид = ВидГруппыФормы.ГруппаКнопок;
		ГруппаТН.Заголовок = "Торговая надбавка,%";
		
		СтавкиКнопка = Элементы.Добавить("ЗаполнитьСтавкуТН", Тип("КнопкаФормы"), ГруппаТН);
		СтавкиКнопка.Заголовок = "Заполнить % ТН";
		ЗаполнитьСтавкуТНКоманда = Команды.Добавить("ЗаполнитьСтавкуТН");
		ЗаполнитьСтавкуТНКоманда.Действие = "ЗаполнитьСтавкуТН";
		СтавкиКнопка.ИмяКоманды = "ЗаполнитьСтавкуТН";
		
		СтавкиКнопка = Элементы.Добавить("ЗаполнитьСтавкуТНДляВыделенныхСтрок", Тип("КнопкаФормы"), ГруппаТН);
		СтавкиКнопка.Заголовок = "Заполнить % ТН для выделенных строк";
		ЗаполнитьСтавкуТНДляВыделенныхСтрокКоманда = Команды.Добавить("ЗаполнитьСтавкуТНДляВыделенныхСтрок");
		ЗаполнитьСтавкуТНДляВыделенныхСтрокКоманда.Действие = "ЗаполнитьСтавкуТНДляВыделенныхСтрок";
		СтавкиКнопка.ИмяКоманды = "ЗаполнитьСтавкуТНДляВыделенныхСтрок";
		
		//НДС
		ГруппаНДС = Элементы.Добавить("ГруппаНДС", Тип("ГруппаФормы"),  ГруппаСтавки);
		ГруппаНДС.вид = ВидГруппыФормы.ГруппаКнопок;
		ГруппаНДС.Заголовок = "Розничная ставка НДС,%";
		
		СтавкиКнопка = Элементы.Добавить("ЗаполнитьСтавкуРозничногоНДС", Тип("КнопкаФормы"), ГруппаНДС);
		СтавкиКнопка.Заголовок = "Заполнить % розн. НДС";
		ЗаполнитьСтавкуРОзничногоНДСКоманда = Команды.Добавить("ЗаполнитьСтавкуРозничногоНДС");
		ЗаполнитьСтавкуРОзничногоНДСКоманда.Действие = "ЗаполнитьСтавкуРозничногоНДС";
		СтавкиКнопка.ИмяКоманды = "ЗаполнитьСтавкуРозничногоНДС";
		
		СтавкиКнопка = Элементы.Добавить("ЗаполнитьСтавкуРозничногоНДСДляВыделенныхСтрок", Тип("КнопкаФормы"), ГруппаНДС);
		СтавкиКнопка.Заголовок = "Заполнить % розн. НДС для выделенных строк";
		ЗаполнитьСтавкуРОзничногоНДСДляВыделенныхСтрокКоманда = Команды.Добавить("ЗаполнитьСтавкуРозничногоНДСДляВыделенныхСтрок");
		ЗаполнитьСтавкуРОзничногоНДСДляВыделенныхСтрокКоманда.Действие = "ЗаполнитьСтавкуРозничногоНДСДляВыделенныхСтрок";
		СтавкиКнопка.ИмяКоманды = "ЗаполнитьСтавкуРозничногоНДСДляВыделенныхСтрок";
		
	КонецЕсли;
	
КонецПроцедуры

Функция ОкруглитьЦенуПоПравиламЦенообразования(ЗначениеЦены, СтрокаСправочникаВидовЦен)  Экспорт
	
	КоличествоСтрок = СтрокаСправочникаВидовЦен.ПравилаОкругленияЦены.Количество();
	
	Для Индекс = 1 По КоличествоСтрок Цикл
		
		ПравилаОкругления = СтрокаСправочникаВидовЦен.ПравилаОкругленияЦены[КоличествоСтрок - Индекс];
		
		Если ПравилаОкругления.НижняяГраницаДиапазонаЦен <= ЗначениеЦены Тогда
			
			Если ЗначениеЗаполнено(ПравилаОкругления.ТочностьОкругления) Тогда
				ЗначениеЦены = ОкруглитьЦену(
								ЗначениеЦены,
								ПравилаОкругления.ТочностьОкругления,
								СтрокаСправочникаВидовЦен.ОкруглятьВБольшуюСторону);
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ПравилаОкругления.ПсихологическоеОкругление) Тогда
				ЗначениеЦены = ЦенообразованиеКлиентСервер.ПрименитьПсихологическоеОкругление(
								ЗначениеЦены,
								ПравилаОкругления.ПсихологическоеОкругление);
			КонецЕсли;
			
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ЗначениеЦены;
	
КонецФункции

// Округляет число по заданному порядку.
//
// Параметры:
// Число                    - исходное число.
// ТочностьОкругления       - Число, определяет точность округления.
// ОкруглятьВБольшуюСторону - булево, определяет способ округления: если Истина, 
//                            то при округлении с точностью до 1, 0.01 будет округлено до 1, 
//                            Ложь - округление по арифметическим правилам.
//
// Возвращаемое значение:
// Число
// Исходное число, округленное с заданной точностью.
//
Функция ОкруглитьЦену(Число, ТочностьОкругления, ОкруглятьВБольшуюСторону) Экспорт

	Перем Результат;
		
	// Вычислим количество интервалов, входящих в число.
	КоличествоИнтервалов = Число / ТочностьОкругления;
		
	// Вычислим целое количество интервалов.
	КоличествоЦелыхИнтервалов = Цел(КоличествоИнтервалов);
		
	Если КоличествоИнтервалов = КоличествоЦелыхИнтервалов Тогда
		// Числа поделились нацело. Округлять не нужно.
		Результат = Число;
	Иначе
		Если ОкруглятьВБольшуюСторону Тогда
			// При порядке округления "0.05" 0.371 должно округлиться до 0.4.
			Результат = ТочностьОкругления * (КоличествоЦелыхИнтервалов + 1);
		Иначе
			// При порядке округления "0.05" 0.371 должно округлиться до 0.35,
			// а 0.376 до 0.4
			Результат = ТочностьОкругления * Окр(КоличествоИнтервалов, 0, РежимОкругления.Окр15как20);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ЕстьРеквизитФормы(Форма, ИмяРеквизита) 
	
	Для Каждого РеквизитФормы Из Форма.ПолучитьРеквизиты() Цикл
		Если ВРег(РеквизитФормы.Имя) = ВРег(ИмяРеквизита) Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

#Область ПеремещениеТоваров

Функция ПолучитьЦенаВключаетНДС(ВидЦены) Экспорт

	Если ЗначениеЗаполнено(ВидЦены) Тогда
		Возврат ВидЦены.ЦенаВключаетНДС;
	Иначе	
	    Возврат Ложь;
	КонецЕсли; 	

КонецФункции 
 
	
#КонецОбласти 

 
