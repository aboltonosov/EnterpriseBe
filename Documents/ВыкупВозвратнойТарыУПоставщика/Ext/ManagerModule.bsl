﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов


// Заполняет список команд создания на основании.
// 
// Параметры:
//   КомандыСоздатьНаОсновании - ТаблицаЗначений - состав полей см. в функции ВводНаОсновании.СоздатьКоллекциюКомандСоздатьНаОсновании
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСоздатьНаОсновании) Экспорт

	ВводНаОснованииПереопределяемый.ДобавитьКомандуСоздатьНаОснованииБизнесПроцессЗадание(КомандыСоздатьНаОсновании);

КонецПроцедуры

// Заполняет список команд создания на основании.
// 
// Параметры:
//   КомандыСоздатьНаОсновании - ТаблицаЗначений - состав полей см. в функции ВводНаОсновании.СоздатьКоллекциюКомандСоздатьНаОсновании
//
// Возвращаемое значение:
//	 КомандыСоздатьНаОсновании - ТаблицаЗначений - состав полей см. в функции ВводНаОсновании.СоздатьКоллекциюКомандСоздатьНаОсновании
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании) Экспорт

	 
	Если ПравоДоступа("Добавление", Метаданные.Документы.ВыкупВозвратнойТарыУПоставщика) Тогда
		КомандаСоздатьНаОсновании = КомандыСоздатьНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Идентификатор = Метаданные.Документы.ВыкупВозвратнойТарыУПоставщика.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ВводНаОсновании.ПредставлениеОбъекта(Метаданные.Документы.ВыкупВозвратнойТарыУПоставщика);
		КомандаСоздатьНаОсновании.ПроверкаПроведенияПередСозданиемНаОсновании = Истина;
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьМногооборотнуюТару";
	

		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;

	Возврат Неопределено;
КонецФункции

// Заполняет список команд отчетов.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов) Экспорт

	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуСтруктураПодчиненности(КомандыОтчетов);

	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуДвиженияДокумента(КомандыОтчетов);

	КомандаОтчет = ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуКарточкаРасчетовПоПринятойВозвратнойТаре(КомандыОтчетов);
	Если КомандаОтчет <> Неопределено Тогда
		КомандаОтчет.СписокФорм = "ФормаДокумента,ФормаСписка";
	КонецЕсли;
	
	КомандаОтчет = ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуКарточкаРасчетовСПоставщикомПоДокументам(КомандыОтчетов);
	Если КомандаОтчет <> Неопределено Тогда
		КомандаОтчет.СписокФорм = "ФормаДокумента,ФормаСписка";
	КонецЕсли;

	КомандаОтчет = ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуСостояниеРасчетовСПоставщикомПоДокументам(КомандыОтчетов);
	Если КомандаОтчет <> Неопределено Тогда
		КомандаОтчет.СписокФорм = "ФормаДокумента,ФормаСписка";
	КонецЕсли;

КонецПроцедуры


// Функция определяет реквизиты выбранного документа.
//
// Параметры:
//  ДокументСсылка - Ссылка на документа
//
// Возвращаемое значение:
//	Структура - реквизиты выбранного документа
//
Функция РеквизитыДокумента(ДокументСсылка) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Дата,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Партнер КАК Партнер,
	|	ДанныеДокумента.Контрагент КАК Контрагент,
	|	ДанныеДокумента.ВалютаВзаиморасчетов КАК ВалютаВзаиморасчетов,
	|	ДанныеДокумента.СуммаДокумента КАК СуммаДокумента,
	|	ДанныеДокумента.СуммаВзаиморасчетов КАК СуммаВзаиморасчетов,
	|	ДанныеДокумента.Проведен КАК Проведен,
	|	ДанныеДокумента.Договор КАК Договор,
	|	ДанныеДокумента.ПорядокРасчетов КАК ПорядокРасчетов,
	|	ДанныеДокумента.Курс КАК Курс,
	|	ДанныеДокумента.Кратность КАК Кратность
	|
	|ИЗ
	|	Документ.ВыкупВозвратнойТарыУПоставщика КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &ДокументСсылка
	|");
	
	Запрос.УстановитьПараметр("ДокументСсылка", ДокументСсылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Дата = Выборка.Дата;
		Организация = Выборка.Организация;
		Партнер = Выборка.Партнер;
		Контрагент = Выборка.Контрагент;
		Договор = Выборка.Договор;
		ПорядокРасчетов = Выборка.ПорядокРасчетов;
		Валюта = Выборка.Валюта;
		ВалютаВзаиморасчетов = Выборка.ВалютаВзаиморасчетов;
		ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщика;
		СуммаДокумента = Выборка.СуммаДокумента;
		СуммаВзаиморасчетов = ?(Выборка.Проведен, Выборка.СуммаВзаиморасчетов, 0);
		Кратность = Выборка.Кратность;
		Курс = Выборка.Курс;
	Иначе
		Дата = Дата(1,1,1);
		Организация = Справочники.Организации.ПустаяСсылка();
		Партнер = Справочники.Партнеры.ПустаяСсылка();
		Контрагент = Справочники.Контрагенты.ПустаяСсылка();
		Договор = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
		ПорядокРасчетов = Перечисления.ПорядокРасчетов.ПустаяСсылка();
		Валюта = Справочники.Валюты.ПустаяСсылка();
		ВалютаВзаиморасчетов = Справочники.Валюты.ПустаяСсылка();
		ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ЗакупкаУПоставщика;
		СуммаДокумента = 0;
		СуммаВзаиморасчетов = 0;
		Кратность = 1;
		Курс = 1;
	КонецЕсли;
	
	СтруктураРеквизитов = Новый Структура("Дата, Организация, Партнер, Контрагент, Договор, ПорядокРасчетов, Валюта, ВалютаВзаиморасчетов, ХозяйственнаяОперация, СуммаДокумента, СуммаВзаиморасчетов, Курс, Кратность",
		Дата,
		Организация,
		Партнер,
		Контрагент,
		Договор,
		ПорядокРасчетов,
		Валюта,
		ВалютаВзаиморасчетов,
		ХозяйственнаяОперация,
		СуммаДокумента,
		СуммаВзаиморасчетов,
		Курс,
		Кратность);
	
	Возврат СтруктураРеквизитов;

КонецФункции

//++ НЕ УТ
#Область ПроводкиРеглУчета

// Функция возвращает текст запроса для отражения документа в регламентированном учете.
//
// Возвращаемое значение:
//	Строка - Текст запроса
//
Функция ТекстОтраженияВРеглУчете() Экспорт
	
	ТекстЗапроса = "";
	
	//++ НЕ УТКА
	
#Область СписаниеВозвратнойТарыДавальца // (Дт :: Кт 003.01 )
	ТекстЗапроса = "
	|ВЫБРАТЬ //// Списание возвратной тары давальца (Дт :: Кт 003.01 )
	|	Операция.Ссылка 		КАК Ссылка,
	|	Операция.Дата			КАК Период,
	|	Операция.Организация	КАК Организация,
	|	НЕОПРЕДЕЛЕНО			КАК ИдентификаторСтроки,
	|
	|	0 КАК Сумма,
	|	
	|	НЕОПРЕДЕЛЕНО КАК ВидСчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК АналитикаУчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаДт,
	|
	|	НЕОПРЕДЕЛЕНО КАК ВалютаДт,
	|	НЕОПРЕДЕЛЕНО КАК ПодразделениеДт,
	|	ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка) КАК НаправлениеДеятельностиДт,
	|
	|	НЕОПРЕДЕЛЕНО КАК СчетДт,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|
	|	0 КАК ВалютнаяСуммаДт,
	|	0 КАК КоличествоДт,
	|	0 КАК СуммаНУДт,
	|	0 КАК СуммаПРДт,
	|	0 КАК СуммаВРДт,
	|
	|	НЕОПРЕДЕЛЕНО КАК ВидСчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК АналитикаУчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаКт,
	|
	|	НЕОПРЕДЕЛЕНО			КАК ВалютаКт,
	|	Операция.Подразделение	КАК ПодразделениеКт,
	|	ЗНАЧЕНИЕ(Справочник.НаправленияДеятельности.ПустаяСсылка) КАК НаправлениеДеятельностиКт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.МатериалыПринятыеВПереработку) КАК СчетКт,
	|	Операция.Контрагент		КАК СубконтоКт1,
	|	Строки.Номенклатура		КАК СубконтоКт2,
	|	Операция.Склад			КАК СубконтоКт3,
	|	
	|	0					КАК ВалютнаяСуммаКт,
	|	Строки.Количество	КАК КоличествоКт,
	|	0					КАК СуммаНУКт,
	|	0					КАК СуммаПРКт,
	|	0					КАК СуммаВРКт,
	|	""Списание возвратной тары давальца"" КАК Содержание
	|
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.ВозвратСырьяДавальцу КАК Операция
	|	ПО
	|		ДокументыКОтражению.Ссылка = Операция.Ссылка
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.ВыкупВозвратнойТарыУПоставщика.Товары КАК Строки
	|	ПО
	|		Строки.Ссылка = Операция.Ссылка
	|		И ТИПЗНАЧЕНИЯ(Строки.ДокументПоступления) = ТИП(Документ.ПоступлениеСырьяОтДавальца)
	|";
#КонецОбласти

	//-- НЕ УТКА

	Возврат ТекстЗапроса;
	
КонецФункции

// Функция возвращает текст запроса дополнительных временных таблиц, 
// необходимых для отражения в регламентированном учете
//
// Возвращаемое значение:
//	Строка - текст запроса
//
Функция ТекстЗапросаВТОтраженияВРеглУчете() Экспорт
	
	ТекстЗапроса = "";
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти
//-- НЕ УТ

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных; 

КонецФункции

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеДокумента.Дата КАК Период,
	|	ДанныеДокумента.Валюта КАК Валюта,
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Партнер КАК Партнер,
	|	ДанныеДокумента.Контрагент КАК Контрагент,
	|	ДанныеДокумента.ПредусмотренЗалогЗаТару КАК ПредусмотренЗалогЗаТару,
	|	ДанныеДокумента.ДатаПлатежа КАК ДатаПлатежа,
	|	ДанныеДокумента.ВалютаВзаиморасчетов КАК ВалютаВзаиморасчетов,
	|	ДанныеДокумента.ФормаОплаты КАК ФормаОплаты,
	|	ДанныеДокумента.Договор КАК Договор,
	|	ВЫБОР КОГДА ДанныеДокумента.ПорядокРасчетов = ЗНАЧЕНИЕ(Перечисление.ПорядокРасчетов.ПоДоговорамКонтрагентов) ТОГДА
	|		ИСТИНА
	|	ИНАЧЕ
	|		ЛОЖЬ
	|	КОНЕЦ КАК РасчетыПоДоговорам,
	|	ДанныеДокумента.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ВЫБОР КОГДА ДанныеДокумента.ПорядокРасчетов = ЗНАЧЕНИЕ(Перечисление.ПорядокРасчетов.ПоДоговорамКонтрагентов)
	|		И ЕСТЬNULL(ДанныеДокумента.Договор.ЗаданГрафикИсполнения, ЛОЖЬ) ТОГДА
	|		Истина
	|	ИНАЧЕ
	|		Ложь
	|	КОНЕЦ КАК ГрафикИсполненияВДоговоре
	|
	|ИЗ
	|	Документ.ВыкупВозвратнойТарыУПоставщика КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Коэффициенты = РаботаСКурсамивалютУТ.ПолучитьКоэффициентыПересчетаВалюты(Реквизиты.Валюта, Реквизиты.ВалютаВзаиморасчетов, Реквизиты.Период);
	
	Запрос.УстановитьПараметр("Период",                                        Реквизиты.Период);
	Запрос.УстановитьПараметр("Партнер",                                       Реквизиты.Партнер);
	Запрос.УстановитьПараметр("Организация",                                   Реквизиты.Организация);
	Запрос.УстановитьПараметр("Валюта",                                        Реквизиты.Валюта);
	Запрос.УстановитьПараметр("ПредусмотренЗалогЗаТару",                       Реквизиты.ПредусмотренЗалогЗаТару);
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета",                Константы.ВалютаРегламентированногоУчета.Получить());
	Запрос.УстановитьПараметр("ДатаПлатежа",                                   Реквизиты.ДатаПлатежа);
	Запрос.УстановитьПараметр("ФормаОплаты",                                   Реквизиты.ФормаОплаты);
	Запрос.УстановитьПараметр("ВалютаВзаиморасчетов",                          Реквизиты.ВалютаВзаиморасчетов);
	Запрос.УстановитьПараметр("КоэффициентПересчетаВВалютуУПР",                Коэффициенты.КоэффициентПересчетаВВалютуУПР);
	Запрос.УстановитьПараметр("КоэффициентПересчетаВВалютуРегл",               Коэффициенты.КоэффициентПересчетаВВалютуРегл);
	Запрос.УстановитьПараметр("Договор",                                       Реквизиты.Договор);
	Запрос.УстановитьПараметр("РасчетыПоДоговорам",                            Реквизиты.РасчетыПоДоговорам);
	Запрос.УстановитьПараметр("АналитикаУчетаПоПартнерам",                     РегистрыСведений.АналитикаУчетаПоПартнерам.ЗначениеКлючаАналитики(Реквизиты));
	Запрос.УстановитьПараметр("ГрафикИсполненияВДоговоре",                     Реквизиты.ГрафикИсполненияВДоговоре);
	
КонецПроцедуры

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт

	////////////////////////////////////////////////////////////////////////////
	// Создадим запрос инициализации движений
	
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка, ДополнительныеСвойства);
	
	////////////////////////////////////////////////////////////////////////////
	// Сформируем текст запроса
	
	ТекстыЗапроса = Новый СписокЗначений;
	ТекстЗапросаТаблицаПринятаяВозвратнаяТара(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаСуммыДокументовВВалютеРегл(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаРасчетыСПоставщиками(Запрос, ТекстыЗапроса, Регистры);

	ПроведениеСерверУТ.ИницализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
			
КонецПроцедуры

Функция ТекстЗапросаТаблицаПринятаяВозвратнаяТара(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПринятаяВозвратнаяТара";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;

	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ТаблицаТовары.НомерСтроки              КАК НомерСтроки,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	&Период                                КАК Период,
	|	ТаблицаТовары.Номенклатура             КАК Номенклатура,
	|	ТаблицаТовары.Характеристика           КАК Характеристика,
	|	ТаблицаТовары.Количество               КАК Количество,
	|	ТаблицаТовары.СуммаСНДС                КАК Сумма,
	|	&Партнер                               КАК Партнер,
	|	ТаблицаТовары.ДокументПоступления      КАК ДокументПоступления,
	|	ИСТИНА                                 КАК Выкуп,
	|	&ПредусмотренЗалогЗаТару               КАК ПредусмотренЗалог
	|ИЗ
	|	Документ.ВыкупВозвратнойТарыУПоставщика.Товары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка
	|	И ТаблицаТовары.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаСуммыДокументовВВалютеРегл(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "СуммыДокументовВВалютеРегл";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ТаблицаТовары.НомерСтроки КАК НомерСтроки,
	|	&Период КАК Период,
	|	&Валюта КАК Валюта,
	|	ТаблицаТовары.ИдентификаторСтроки КАК ИдентификаторСтроки,
	|	ТаблицаТовары.СуммаСНДС - ТаблицаТовары.СуммаНДС КАК СуммаБезНДС,
	|	ТаблицаТовары.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаТовары.СуммаНДС КАК СуммаНДС,
	|	(ТаблицаТовары.СуммаСНДС - ТаблицаТовары.СуммаНДС)*&КоэффициентПересчетаВВалютуРегл КАК СуммаБезНДСРегл,
	|	ТаблицаТовары.СуммаНДС*&КоэффициентПересчетаВВалютуРегл КАК СуммаНДСРегл,
	|	(ТаблицаТовары.СуммаСНДС - ТаблицаТовары.СуммаНДС)*&КоэффициентПересчетаВВалютуРегл КАК БазаНДСРегл,
	|	НЕОПРЕДЕЛЕНО КАК ТипРасчетов
	|
	|ИЗ
	|	Документ.ВыкупВозвратнойТарыУПоставщика.Товары КАК ТаблицаТовары
	|
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка
	|	И &Валюта <> &ВалютаРегламентированногоУчета
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаРасчетыСПоставщиками(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "РасчетыСПоставщиками";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	&Период КАК Период,
	|	&Период КАК ДатаРегистратора,
	|	&ДатаПлатежа КАК ДатаПлатежа,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	&АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
	|
	|	ВЫБОР КОГДА &РасчетыПоДоговорам ТОГДА
	|		&Договор
	|	ИНАЧЕ
	|		&Ссылка
	|	КОНЕЦ КАК ЗаказПоставщику,
	|
	|	Неопределено КАК ЗакупкаПоЗаказу,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗакупкаУПоставщика) КАК ХозяйственнаяОперация,
	|	&ВалютаВзаиморасчетов КАК Валюта,
	|	Неопределено КАК ФормаОплаты,
	|	ДанныеДокумента.СуммаВзаиморасчетов КАК Сумма,
	|	0 КАК КОплате,
	|	0 КАК КОтгрузке,
	|	ВЫРАЗИТЬ(ДанныеДокумента.СуммаДокумента * &КоэффициентПересчетаВВалютуРегл КАК ЧИСЛО(15, 2)) КАК СуммаРегл,
	|	ВЫРАЗИТЬ(ДанныеДокумента.СуммаДокумента * &КоэффициентПересчетаВВалютуУпр КАК ЧИСЛО(15, 2)) КАК СуммаУпр,
	|	&Организация КАК Организация
	|ИЗ
	|	Документ.ВыкупВозвратнойТарыУПоставщика КАК ДанныеДокумента
	|
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|	И НЕ &ПредусмотренЗалогЗаТару
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	КОНЕЦПЕРИОДА(&ДатаПлатежа, День) КАК Период,
	|	&Период КАК ДатаРегистратора,
	|	&ДатаПлатежа КАК ДатаПлатежа,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	&АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
	|
	|	ВЫБОР КОГДА &РасчетыПоДоговорам ТОГДА
	|		&Договор
	|	ИНАЧЕ
	|		&Ссылка
	|	КОНЕЦ КАК ЗаказПоставщику,
	|
	|	Неопределено КАК ЗакупкаПоЗаказу,
	|	ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ЗакупкаУПоставщика) КАК ХозяйственнаяОперация,
	|	&ВалютаВзаиморасчетов КАК Валюта,
	|	&ФормаОплаты КАК ФормаОплаты,
	|	0 КАК Сумма,
	|	ДанныеДокумента.СуммаВзаиморасчетов КАК КОплате,
	|	0 КАК КОтгрузке,
	|	0 КАК СуммаРегл,
	|	0 КАК СуммаУпр,
	|	&Организация КАК Организация
	|ИЗ
	|	Документ.ВыкупВозвратнойТарыУПоставщика КАК ДанныеДокумента
	|
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка
	|	И НЕ &ПредусмотренЗалогЗаТару
	|	И НЕ &ГрафикИсполненияВДоговоре
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

// Обработчик обновления УП 2.2.1,
// заполняет реквизиты "Порядок оплаты", "Курс" и "Кратность" документа "ВыкупВозвратнойТарыУПоставщика".
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ВыкупВозвратнойТарыУПоставщика.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ВыкупВозвратнойТарыУПоставщика КАК ВыкупВозвратнойТарыУПоставщика
	|ГДЕ ВыкупВозвратнойТарыУПоставщика.ПорядокОплаты = Значение(Перечисление.ПорядокОплатыПоСоглашениям.ПустаяСсылка)
	|		ИЛИ (ВыкупВозвратнойТарыУПоставщика.Курс = 0 И НЕ ВыкупВозвратнойТарыУПоставщика.Валюта = ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) 
	|			И НЕ ВыкупВозвратнойТарыУПоставщика.ВалютаВзаиморасчетов = ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка))
	|");
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяОбъекта = "Документ.ВыкупВозвратнойТарыУПоставщика";
	
	МетаданныеДокумента = Метаданные.НайтиПоПолномуИмени(ПолноеИмяОбъекта);
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Результат = ОбновлениеИнформационнойБазы.СоздатьВременнуюТаблицуСсылокДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта, МенеджерВременныхТаблиц);
	
	Если НЕ Результат.ЕстьДанныеДляОбработки Тогда
		Параметры.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;
	Если НЕ Результат.ЕстьЗаписиВоВременнойТаблице Тогда
		Параметры.ОбработкаЗавершена = Ложь;
		Возврат;
	КонецЕсли; 
	
	ВалютаРеглУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ОбъектыДляОбработки.Ссылка                      КАК Ссылка,
	|	ОбъектыДляОбработки.Ссылка.ВерсияДанных         КАК ВерсияДанных,
	|	ВЫБОР 
	|		КОГДА НЕ ОбъектыДляОбработки.Ссылка.Договор = ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка)
	|			ТОГДА ОбъектыДляОбработки.Ссылка.Договор.ПорядокОплаты
	|		КОГДА НЕ ОбъектыДляОбработки.Ссылка.Соглашение = ЗНАЧЕНИЕ(Справочник.СоглашенияСКлиентами.ПустаяСсылка)
	|			И НЕ ОбъектыДляОбработки.Ссылка.Соглашение = ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка)
	|			ТОГДА ОбъектыДляОбработки.Ссылка.Соглашение.ПорядокОплаты
	|		ИНАЧЕ	ВЫБОР
	|					КОГДА ОбъектыДляОбработки.Ссылка.ВалютаВзаиморасчетов = &ВалютаРеглУчета 
	|						ТОГДА ЗНАЧЕНИЕ(Перечисление.ПорядокОплатыПоСоглашениям.РасчетыВРубляхОплатаВРублях)
	|					ИНАЧЕ
	|						ЗНАЧЕНИЕ(Перечисление.ПорядокОплатыПоСоглашениям.РасчетыВВалютеОплатаВРублях)
	|				КОНЕЦ
	|	КОНЕЦ                                           КАК ПорядокОплаты,
	|	ОбъектыДляОбработки.Ссылка.Дата                 КАК Дата,
	|	ОбъектыДляОбработки.Ссылка.Валюта               КАК Валюта,
	|	ОбъектыДляОбработки.Ссылка.ВалютаВзаиморасчетов КАК ВалютаВзаиморасчетов,
	|	ОбъектыДляОбработки.Ссылка.СуммаВзаиморасчетов  КАК СуммаВзаиморасчетов,
	|	ОбъектыДляОбработки.Ссылка.СуммаДокумента       КАК СуммаДокумента
	|ПОМЕСТИТЬ ТаблицаСсылок
	|ИЗ
	|	ВТОбъектыДляОбработки КАК ОбъектыДляОбработки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаСсылок.Дата          КАК Дата,
	|	ТаблицаСсылок.Валюта        КАК Валюта,
	|	МАКСИМУМ(КурсыВалют.Период) КАК ДатаКурса
	|ПОМЕСТИТЬ ДатыКурсовВалютыДокумента
	|ИЗ
	|	ТаблицаСсылок КАК ТаблицаСсылок
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют КАК КурсыВалют
	|		ПО ТаблицаСсылок.Валюта = КурсыВалют.Валюта
	|			И ТаблицаСсылок.Дата >= КурсыВалют.Период
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаСсылок.Дата,
	|	ТаблицаСсылок.Валюта
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаСсылок.Дата                 КАК Дата,
	|	ТаблицаСсылок.ВалютаВзаиморасчетов КАК Валюта,
	|	МАКСИМУМ(КурсыВалют.Период)        КАК ДатаКурса
	|ПОМЕСТИТЬ ДатыКурсовВалютыВзаиморасчетов
	|ИЗ
	|	ТаблицаСсылок КАК ТаблицаСсылок
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют КАК КурсыВалют
	|		ПО ТаблицаСсылок.ВалютаВзаиморасчетов = КурсыВалют.Валюта
	|			И ТаблицаСсылок.Дата >= КурсыВалют.Период
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаСсылок.Дата,
	|	ТаблицаСсылок.ВалютаВзаиморасчетов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеДляОбработки.Ссылка               КАК Ссылка,
	|	ДанныеДляОбработки.ВерсияДанных         КАК ВерсияДанных,
	|	ДанныеДляОбработки.ПорядокОплаты        КАК ПорядокОплаты,
	|	ДанныеДляОбработки.Валюта               КАК ВалютаДокумента,
	|	ДанныеДляОбработки.ВалютаВзаиморасчетов КАК ВалютаВзаиморасчетов,
	|	ДанныеДляОбработки.СуммаДокумента       КАК СуммаДокумента,
	|	ДанныеДляОбработки.СуммаВзаиморасчетов  КАК СуммаВзаиморасчетов,
	|	ЕСТЬNULL(КурсыВалютыДокумента.Кратность,1)          КАК КратностьВалютыДокумента,
	|	ЕСТЬNULL(КурсыВалютыВзаиморасчетов.Кратность,1)     КАК КратностьВалютыВзаиморасчетов
	|ИЗ
	|	ТаблицаСсылок КАК ДанныеДляОбработки
	|		ЛЕВОЕ СОЕДИНЕНИЕ ДатыКурсовВалютыДокумента КАК ДатыКурсовВалютыДокумента
	|			ЛЕВОЕ СОЕДИНЕНИЕ  РегистрСведений.КурсыВалют КАК КурсыВалютыДокумента
	|			ПО ДатыКурсовВалютыДокумента.ДатаКурса = КурсыВалютыДокумента.Период
	|				И ДатыКурсовВалютыДокумента.Валюта = КурсыВалютыДокумента.Валюта
	|		ПО ДанныеДляОбработки.Валюта = ДатыКурсовВалютыДокумента.Валюта
	|			И ДанныеДляОбработки.Дата = ДатыКурсовВалютыДокумента.Дата
	|		ЛЕВОЕ СОЕДИНЕНИЕ ДатыКурсовВалютыВзаиморасчетов КАК ДатыКурсовВалютыВзаиморасчетов
	|			ЛЕВОЕ СОЕДИНЕНИЕ  РегистрСведений.КурсыВалют КАК КурсыВалютыВзаиморасчетов
	|			ПО ДатыКурсовВалютыВзаиморасчетов.ДатаКурса = КурсыВалютыВзаиморасчетов.Период
	|				И ДатыКурсовВалютыВзаиморасчетов.Валюта = КурсыВалютыВзаиморасчетов.Валюта
	|		ПО ДанныеДляОбработки.ВалютаВзаиморасчетов = ДатыКурсовВалютыВзаиморасчетов.Валюта
	|			И ДанныеДляОбработки.Дата = ДатыКурсовВалютыВзаиморасчетов.Дата
	|";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ВТОбъектыДляОбработки", Результат.ИмяВременнойТаблицы);
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ВалютаРеглУчета", ВалютаРеглУчета);
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Результат = Запрос.Выполнить();
	
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Попытка
			
			НачатьТранзакцию();
			
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			Блокировка.Заблокировать();
			
		Исключение
			
			ОтменитьТранзакцию();
			ТекстСообщения = НСтр("ru = 'Не удалось заблокировать документ: %Ссылка% по причине: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ссылка%", Выборка.Ссылка);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
									УровеньЖурналаРегистрации.Предупреждение,
									МетаданныеДокумента,
									Выборка.Ссылка,
									ТекстСообщения);
			Продолжить;
			
		КонецПопытки;
		
		ДокументОбъект = ОбновлениеИнформационнойБазыУТ.ПроверитьПолучитьОбъект(Выборка.Ссылка, Выборка.ВерсияДанных, Параметры.Очередь);
		Если ДокументОбъект = Неопределено Тогда
			ЗафиксироватьТранзакцию();
			Продолжить;
		КонецЕсли;
		
		ОбъектИзменен = Ложь;
		
		Если НЕ ЗначениеЗаполнено(ДокументОбъект.ПорядокОплаты) Тогда
			Если ЗначениеЗаполнено(Выборка.ПорядокОплаты) Тогда
				ДокументОбъект.ПорядокОплаты = Выборка.ПорядокОплаты;
			Иначе
				ДокументОбъект.ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.РасчетыВРубляхОплатаВРублях;
			КонецЕсли;
			ОбъектИзменен = Истина;
		КонецЕсли;
		
		Если ДокументОбъект.Курс = 0 И ЗначениеЗаполнено(ДокументОбъект.Валюта) И ЗначениеЗаполнено(ДокументОбъект.ВалютаВзаиморасчетов) Тогда
			Если Выборка.СуммаВзаиморасчетов = 0 ИЛИ Выборка.СуммаДокумента = 0 ИЛИ Выборка.ВалютаДокумента = Выборка.ВалютаВзаиморасчетов Тогда
				ДокументОбъект.Курс = 1;
				ДокументОбъект.Кратность = 1;
			ИначеЕсли Выборка.ВалютаДокумента = ВалютаРеглУчета И НЕ Выборка.ВалютаВзаиморасчетов = ВалютаРеглУчета Тогда
				ДокументОбъект.Курс = Окр(Выборка.СуммаДокумента / Выборка.СуммаВзаиморасчетов * Выборка.КратностьВалютыВзаиморасчетов, 4);
				ДокументОбъект.Кратность = Выборка.КратностьВалютыВзаиморасчетов;
			Иначе
				ДокументОбъект.Курс = Окр(Выборка.СуммаВзаиморасчетов / Выборка.СуммаДокумента * Выборка.КратностьВалютыДокумента, 4);
				ДокументОбъект.Кратность = Выборка.КратностьВалютыДокумента;
			КонецЕсли;
			ОбъектИзменен = Истина;
		КонецЕсли;
	
		Попытка
			
			Если ОбъектИзменен Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ДокументОбъект, , , РежимЗаписиДокумента.Запись);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка);
			КонецЕсли;
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			ТекстСообщения = НСтр("ru = 'Не удалось обработать документ: %Ссылка% по причине: %Причина%'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Ссылка%", Выборка.Ссылка);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Причина%", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Предупреждение,
				МетаданныеДокумента,
				Выборка.Ссылка,
				ТекстСообщения);
			ВызватьИсключение;
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = Не ОбновлениеИнформационнойБазы.ЕстьДанныеДляОбработки(Параметры.Очередь, ПолноеИмяОбъекта);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли