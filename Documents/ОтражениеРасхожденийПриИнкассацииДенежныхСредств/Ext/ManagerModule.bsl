﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет список команд создания на основании.
// 
// Параметры:
//   КомандыСоздатьНаОсновании - ТаблицаЗначений - состав полей см. в функции ВводНаОсновании.СоздатьКоллекциюКомандСоздатьНаОсновании
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСоздатьНаОсновании) Экспорт



КонецПроцедуры

Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании) Экспорт

	 
	Если ПравоДоступа("Добавление", Метаданные.Документы.ОтражениеРасхожденийПриИнкассацииДенежныхСредств) Тогда
		КомандаСоздатьНаОсновании = КомандыСоздатьНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Идентификатор = Метаданные.Документы.ОтражениеРасхожденийПриИнкассацииДенежныхСредств.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ВводНаОсновании.ПредставлениеОбъекта(Метаданные.Документы.ОтражениеРасхожденийПриИнкассацииДенежныхСредств);
		КомандаСоздатьНаОсновании.ПроверкаПроведенияПередСозданиемНаОсновании = Истина;
		
	

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

КонецПроцедуры


//++ НЕ УТ

// Возвращает текст запроса для отражения документа в регламентированном учете.
//
// Возвращаемое значение:
//	Строка - Текст запроса
//
Функция ТекстОтраженияВРеглУчете() Экспорт

#Область Доходы

	ТекстДоходы = "
	|ВЫБРАТЬ //Излишек при инкасации ДС (Дт <57>:: Кт <91.01>)
	|
	|	Операция.Ссылка КАК Ссылка,
	|	Операция.Дата КАК Период,
	|	Операция.Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,
	|
	|	ЕСТЬNULL(Суммы.СуммаБезНДСРегл, Операция.Сумма) КАК Сумма,
	|
	|	НЕОПРЕДЕЛЕНО КАК ВидСчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК ГруппаФинансовогоУчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаДт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаДт,
	|	Операция.БанковскийСчет.Подразделение КАК ПодразделениеДт,
	|	Операция.БанковскийСчет.НаправлениеДеятельности КАК НаправлениеДеятельностиДт,
	|	
	|	ВЫБОР КОГДА Операция.Валюта = Константы.ВалютаРегламентированногоУчета ТОГДА
	|		ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПереводыВПути)
	|	ИНАЧЕ
	|		ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПереводыВПутиВал)
	|	КОНЕЦ
	|	КАК СчетДт,
	|	
	|	Операция.СтатьяДвиженияДенежныхСредств КАК СубконтоДт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоДт3,
	|	
	|	ВЫБОР КОГДА Операция.Валюта = Константы.ВалютаРегламентированногоУчета ТОГДА
	|		0
	|	ИНАЧЕ
	|		Операция.Сумма 
	|	КОНЕЦ КАК ВалютнаяСуммаДт,
	|	0 КАК КоличествоДт,
	|	0 КАК СуммаНУДт,
	|	0 КАК СуммаПРДт,
	|	0 КАК СуммаВРДт,
	|	
	|	НЕОПРЕДЕЛЕНО КАК ВидСчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК АналитикаУчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаКт,
	|
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаКт,
	|	Операция.Подразделение КАК ПодразделениеКт,
	|	Операция.БанковскийСчет.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПрочиеДоходы) КАК СчетКт,
	|	Операция.СтатьяДоходов КАК СубконтоКт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|
	|	0 КАК ВалютнаяСуммаКт,
	|	0 КАК КоличествоКт,
	|	0 КАК СуммаНУКт,
	|	0 КАК СуммаПРКт,
	|	0 КАК СуммаВРКт,
	|	""Излишек при инкассации ДС"" КАК Содержание
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.ОтражениеРасхожденийПриИнкассацииДенежныхСредств КАК Операция
	|	ПО
	|		ДокументыКОтражению.Ссылка = Операция.Ссылка
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Константы КАК Константы
	|	ПО
	|		Истина
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.СуммыДокументовВВалютеРегл КАК Суммы
	|	ПО
	|		Суммы.Регистратор = Операция.Ссылка
	|		И Суммы.СуммаБезНДСРегл <> 0
	|ГДЕ
	|	Операция.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОтражениеИзлишкаПриИнкассацииДенежныхСредств)
	|";
	
#КонецОбласти

#Область Расходы
	
	ТекстРасходы = "
	|ВЫБРАТЬ // Недостачи при инкассации ДС (Дт <94> :: Кт <57>)
	|
	|	Операция.Ссылка КАК Ссылка,
	|	Операция.Дата КАК Период,
	|	Операция.Организация КАК Организация,
	|	НЕОПРЕДЕЛЕНО КАК ИдентификаторСтроки,
	|	
	|	ЕСТЬNULL(Суммы.СуммаБезНДСРегл, Операция.Сумма) КАК Сумма,
	|
	|	НЕОПРЕДЕЛЕНО КАК ВидСчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК АналитикаУчетаДт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаДт,
	|	
	|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ВалютаДт,
	|	Операция.Подразделение КАК ПодразделениеДт,
	|	Операция.БанковскийСчет.НаправлениеДеятельности КАК НаправлениеДеятельностиДт,
	|
	|	ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.НедостачиИПотериОтПорчиЦенностей) КАК СчетДт,
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
	|	НЕОПРЕДЕЛЕНО КАК ГруппаФинансовогоУчетаКт,
	|	НЕОПРЕДЕЛЕНО КАК МестоУчетаКт,
	|	
	|	Операция.Валюта КАК ВалютаКт,
	|	Операция.БанковскийСчет.Подразделение КАК ПодразделениеКт,
	|	Операция.БанковскийСчет.НаправлениеДеятельности КАК НаправлениеДеятельностиКт,
	|	
	|	ВЫБОР КОГДА Операция.Валюта = Константы.ВалютаРегламентированногоУчета ТОГДА
	|		ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПереводыВПути)
	|	ИНАЧЕ
	|		ЗНАЧЕНИЕ(ПланСчетов.Хозрасчетный.ПереводыВПутиВал)
	|	КОНЕЦ
	|	КАК СчетКт,
	|	
	|	Операция.СтатьяДвиженияДенежныхСредств КАК СубконтоКт1,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт2,
	|	НЕОПРЕДЕЛЕНО КАК СубконтоКт3,
	|	
	|	ВЫБОР КОГДА Операция.Валюта = Константы.ВалютаРегламентированногоУчета ТОГДА
	|		0
	|	ИНАЧЕ
	|		Операция.Сумма 
	|	КОНЕЦ КАК ВалютнаяСуммаКт,
	|	0 КАК КоличествоКт,
	|	0 КАК СуммаНУКт,
	|	0 КАК СуммаПРКт,
	|	0 КАК СуммаВРКт,
	|	""Недостача при инкассации ДС"" КАК Содержание
	|	
	|ИЗ
	|	ДокументыКОтражению КАК ДокументыКОтражению
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Документ.ОтражениеРасхожденийПриИнкассацииДенежныхСредств КАК Операция
	|	ПО
	|		ДокументыКОтражению.Ссылка = Операция.Ссылка
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|		Константы КАК Константы
	|	ПО
	|		Истина
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.СуммыДокументовВВалютеРегл КАК Суммы
	|	ПО
	|		Суммы.Регистратор = Операция.Ссылка
	|		И Суммы.СуммаБезНДСРегл <> 0
	|ГДЕ
	|	Операция.ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОтражениеНедостачиПриИнкассацииДенежныхСредств)
	|";
	
#КонецОбласти
	
	Возврат ТекстДоходы
		+ " ОБЪЕДИНИТЬ ВСЕ " + ТекстРасходы;

КонецФункции

// Функция возвращает текст запроса дополнительных временных таблиц, 
// необходимых для отражения в регламентированном учете
//
// Возвращаемое значение:
//	ТекстЗапроса - Строка - текст запроса создания временных таблиц.
//
Функция ТекстЗапросаВТОтраженияВРеглУчете() Экспорт
	
	Возврат "";
	
КонецФункции

//-- НЕ УТ

// Процедура заполняет массивы реквизитов, зависимых от хозяйственной операции документа.
//
// Параметры:
//	ХозяйственнаяОперация - ПеречислениеСсылка.ХозяйственныеОперации - Выбранная хозяйственная операция
//	МассивВсехРеквизитов - Массив - Массив всех имен реквизитов, зависимых от хозяйственной операции
//	МассивРеквизитовОперации - Массив - Массив имен реквизитов, используемых в выбранной хозяйственной операции
//
Процедура ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(ХозяйственнаяОперация, МассивВсехРеквизитов, МассивРеквизитовОперации) Экспорт
	
	МассивВсехРеквизитов = Новый Массив;
	МассивВсехРеквизитов.Добавить("СтатьяДоходов");
	МассивВсехРеквизитов.Добавить("АналитикаДоходов");
	МассивВсехРеквизитов.Добавить("СтатьяРасходов");
	МассивВсехРеквизитов.Добавить("АналитикаРасходов");
	
	МассивРеквизитовОперации = Новый Массив;
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОтражениеИзлишкаПриИнкассацииДенежныхСредств Тогда
		
		МассивРеквизитовОперации.Добавить("СтатьяДоходов");
		МассивРеквизитовОперации.Добавить("АналитикаДоходов");
	
	ИначеЕсли ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОтражениеНедостачиПриИнкассацииДенежныхСредств Тогда
		
		МассивРеквизитовОперации.Добавить("СтатьяРасходов");
		МассивРеквизитовОперации.Добавить("АналитикаРасходов");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных; 

КонецФункции

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	// Создание запроса инициализации движений и заполенение его параметров
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);

	// Текст запроса, формирующего таблицы движений
	ТекстыЗапроса = Новый СписокЗначений;
	
	ТекстЗапросаПрочиеДоходы(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаПрочиеРасходы(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаПартииПрочихРасходов(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаДенежныеСредстваВПути(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаДвиженияДенежныеСредстваДоходыРасходы(Запрос, ТекстыЗапроса, Регистры);
	
	//++ НЕ УТ
	ТекстЗапросаСуммыДокументовВВалютеРегл(Запрос, ТекстыЗапроса, Регистры);
	//-- НЕ УТ
	
	// Выполение запроса и выгрузка полученных таблиц для формирования движений
	ПроведениеСерверУТ.ИницализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)

	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Дата                                                        КАК Период,
	|	ДанныеДокумента.Организация                                                 КАК Организация,
	|	ДанныеДокумента.ХозяйственнаяОперация                                       КАК ХозяйственнаяОперация,
	|	ДанныеДокумента.БанковскийСчет                                              КАК БанковскийСчет,
	|	ДанныеДокумента.Касса                                                       КАК Касса,
	|	ДанныеДокумента.Сумма                                                       КАК СуммаВВалюте,
	|	ДанныеДокумента.Валюта                                                      КАК Валюта,
	|	
	|	ДанныеДокумента.Подразделение                                               КАК Подразделение,
	|	ДанныеДокумента.БанковскийСчет.Подразделение                                КАК БанковскийСчетПодразделение,
	|	ДанныеДокумента.БанковскийСчет.НаправлениеДеятельности                      КАК НаправлениеДеятельности,
	|	ДанныеДокумента.СтатьяДоходов                                               КАК СтатьяДоходов,
	|	ДанныеДокумента.АналитикаДоходов                                            КАК АналитикаДоходов,
	|	ДанныеДокумента.СтатьяРасходов                                              КАК СтатьяРасходов,
	|	ДанныеДокумента.СтатьяРасходов.ВариантРаспределенияРасходов                 КАК ВариантРаспределенияРасходов,
	|	ДанныеДокумента.СтатьяРасходов.ПринятиеКНалоговомуУчету                     КАК ПринятиеКНалоговомуУчету,
	|	ДанныеДокумента.АналитикаРасходов                                           КАК АналитикаРасходов,
	|	
	|	ДанныеДокумента.СтатьяДвиженияДенежныхСредств                               КАК СтатьяДвиженияДенежныхСредств
	|	
	|ИЗ
	|	Документ.ОтражениеРасхожденийПриИнкассацииДенежныхСредств КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";

	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Результат = Запрос.Выполнить();
	Реквизиты = Результат.Выбрать();
	Реквизиты.Следующий();
	
	Для Каждого Колонка из Результат.Колонки Цикл
		Запрос.УстановитьПараметр(Колонка.Имя, Реквизиты[Колонка.Имя]);
	КонецЦикла;
	
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета", Константы.ВалютаРегламентированногоУчета.Получить());
	
КонецПроцедуры

Процедура УстановитьПараметрыЗапросаСумма(Запрос)
	
	Если Запрос.Параметры.Свойство("Сумма") Тогда
		Возврат;
	КонецЕсли;
	
	ВалютаУправленческогоУчета = Константы.ВалютаУправленческогоУчета.Получить();
	КоэффициентПересчетаВВалютуУпр = РаботаСКурсамиВалютУТ.ПолучитьКоэффициентПересчетаИзВалютыВВалюту(Запрос.Параметры.Валюта,
																										ВалютаУправленческогоУчета,
																										Запрос.Параметры.Период);
	Запрос.УстановитьПараметр("Сумма",                             Запрос.Параметры.СуммаВВалюте * КоэффициентПересчетаВВалютуУпр);
	
КонецПроцедуры

Процедура УстановитьПараметрыЗапросаСуммаРегл(Запрос)
	
	Если Запрос.Параметры.Свойство("СуммаРегл") Тогда
		Возврат;
	КонецЕсли;
	
	КоэффициентПересчетаВВалютуРегл = РаботаСКурсамиВалютУТ.ПолучитьКоэффициентПересчетаИзВалютыВВалюту(Запрос.Параметры.Валюта,
																										Запрос.Параметры.ВалютаРегламентированногоУчета,
																										Запрос.Параметры.Период);
	Запрос.УстановитьПараметр("СуммаРегл",                             Запрос.Параметры.СуммаВВалюте * КоэффициентПересчетаВВалютуРегл);
	
КонецПроцедуры

Функция ТекстЗапросаПрочиеДоходы(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПрочиеДоходы";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	УстановитьПараметрыЗапросаСумма(Запрос);
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)       КАК ВидДвижения,
	|	&Период                                      КАК Период,
	|	
	|	&Организация                                 КАК Организация,
	|	&Подразделение                               КАК Подразделение,
	|	&НаправлениеДеятельности                     КАК НаправлениеДеятельности,
	|	&СтатьяДоходов                               КАК СтатьяДоходов,
	|	&АналитикаДоходов                            КАК АналитикаДоходов,
	|	
	|	&Сумма                                       КАК Сумма,
	|	
	|	&ХозяйственнаяОперация                       КАК ХозяйственнаяОперация
	|	
	|ГДЕ
	|	&ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОтражениеИзлишкаПриИнкассацииДенежныхСредств)";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаПрочиеРасходы(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПрочиеРасходы";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	УстановитьПараметрыЗапросаСумма(Запрос);
	УстановитьПараметрыЗапросаСуммаРегл(Запрос);
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)       КАК ВидДвижения,
	|	&Период                                      КАК Период,
	|	
	|	&Организация                                 КАК Организация,
	|	&Подразделение                               КАК Подразделение,
	|	&НаправлениеДеятельности                     КАК НаправлениеДеятельности,
	|	&СтатьяРасходов                              КАК СтатьяРасходов,
	|	&АналитикаРасходов                           КАК АналитикаРасходов,
	|	
	|	&Сумма                                       КАК Сумма,
	//++ НЕ УТ
	|	ВЫБОР КОГДА СтатьиРасходов.ВариантРаспределенияРасходов = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаПроизводственныеЗатраты) ТОГДА
	|		&Сумма
	|	ИНАЧЕ
	|		0
	|	КОНЕЦ КАК СуммаБезНДС,
	|
	|	&СуммаРегл КАК СуммаРегл,
	|
	|	ВЫБОР КОГДА НЕ СтатьиРасходов.ПринятиеКНалоговомуУчету ТОГДА
	|		&СуммаРегл
	|	ИНАЧЕ
	|		0
	|	КОНЕЦ КАК ПостояннаяРазница,
	|	0 КАК ВременнаяРазница,
	//-- НЕ УТ
	|	
	|	&ХозяйственнаяОперация                       КАК ХозяйственнаяОперация
	|	
	|ИЗ
	|	ПланВидовХарактеристик.СтатьиРасходов КАК СтатьиРасходов
	|ГДЕ
	|	СтатьиРасходов.Ссылка = &СтатьяРасходов
	|	И &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОтражениеНедостачиПриИнкассацииДенежныхСредств)";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаПартииПрочихРасходов(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПартииПрочихРасходов";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	УстановитьПараметрыЗапросаСумма(Запрос);
	УстановитьПараметрыЗапросаСуммаРегл(Запрос);
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)                            КАК ВидДвижения,
	|	&Период                                                           КАК Период,
	|	
	|	&Организация                                                      КАК Организация,
	|	&Подразделение                                                    КАК Подразделение,
	|	&НаправлениеДеятельности                                          КАК НаправлениеДеятельности,
	|	&СтатьяРасходов                                                   КАК СтатьяРасходов,
	|	&АналитикаРасходов                                                КАК АналитикаРасходов,
	|	&Ссылка                                                           КАК ДокументПоступленияРасходов,
	|	ЗНАЧЕНИЕ(Справочник.КлючиАналитикиУчетаПартий.ПустаяСсылка)       КАК АналитикаУчетаПартий,
	|	
	|	&Сумма                                                            КАК Стоимость,
	|	&Сумма                                                            КАК СтоимостьБезНДС,
	|	&СуммаРегл                                                        КАК СтоимостьРегл,
//++ НЕ УТ
	|	ВЫБОР КОГДА &ПринятиеКналоговомуУчету = ЛОЖЬ ТОГДА
	|		&СуммаРегл
	|	ИНАЧЕ
	|		0
	|	КОНЕЦ КАК ПостояннаяРазница,
	|	0 КАК ВременнаяРазница,
//-- НЕ УТ
	|
	|	0 КАК НДСРегл
	|ГДЕ
	|	&ВариантРаспределенияРасходов = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров)";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаДенежныеСредстваВПути(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДенежныеСредстваВПути";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	УстановитьПараметрыЗапросаСумма(Запрос);
	УстановитьПараметрыЗапросаСуммаРегл(Запрос);
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)                                     КАК ВидДвижения,
	|	&Период                                                                    КАК Период,
	|	
	|	&Организация                                                               КАК Организация,
	|	&БанковскийСчет                                                            КАК Получатель,
	|	&Касса                                                                     КАК Отправитель,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыПереводовДенежныхСредств.ИнкассацияВБанк)        КАК ВидПереводаДенежныхСредств,
	|	НЕОПРЕДЕЛЕНО                                                               КАК Контрагент,
	|	&Валюта                                                                    КАК Валюта,
	|	
	|	ВЫБОР КОГДА &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОтражениеИзлишкаПриИнкассацииДенежныхСредств) ТОГДА
	|		&СуммаВВалюте
	|	КОГДА &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОтражениеНедостачиПриИнкассацииДенежныхСредств) ТОГДА
	|		-&СуммаВВалюте
	|	КОНЕЦ КАК Сумма,
	|	ВЫБОР КОГДА &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОтражениеИзлишкаПриИнкассацииДенежныхСредств) ТОГДА
	|		&Сумма
	|	КОГДА &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОтражениеНедостачиПриИнкассацииДенежныхСредств) ТОГДА
	|		-&Сумма
	|	КОНЕЦ КАК СуммаУпр,
	|	ВЫБОР КОГДА &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОтражениеИзлишкаПриИнкассацииДенежныхСредств) ТОГДА
	|		&СуммаРегл
	|	КОГДА &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОтражениеНедостачиПриИнкассацииДенежныхСредств) ТОГДА
	|		-&СуммаРегл
	|	КОНЕЦ КАК СуммаРегл,
	|	
	|	&ХозяйственнаяОперация                                                     КАК ХозяйственнаяОперация,
	|	&СтатьяДвиженияДенежныхСредств                                             КАК СтатьяДвиженияДенежныхСредств
	|";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаДвиженияДенежныеСредстваДоходыРасходы(Запрос, ТекстыЗапроса, Регистры)

	ИмяРегистра = "ДвиженияДенежныеСредстваДоходыРасходы";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	УстановитьПараметрыЗапросаСумма(Запрос);
	УстановитьПараметрыЗапросаСуммаРегл(Запрос);
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	&Период КАК Период,
	|	&ХозяйственнаяОперация КАК ХозяйственнаяОперация,
	|	&Организация КАК Организация,
	|	&БанковскийСчетПодразделение КАК Подразделение,
	|	&НаправлениеДеятельности     КАК НаправлениеДеятельностиДС,
	|	&Подразделение               КАК ПодразделениеДоходовРасходов,
	|
	|	ДанныеДокумента.Касса КАК ДенежныеСредства,
	|	Значение(Перечисление.ТипыДенежныхСредств.Наличные) КАК ТипДенежныхСредств,
	|	&СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
	|	&Валюта КАК Валюта,
	|
	|	&НаправлениеДеятельности     КАК НаправлениеДеятельностиСтатьи,
	|	ВЫБОР КОГДА &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОтражениеНедостачиПриИнкассацииДенежныхСредств) ТОГДА
	|		&СтатьяРасходов
	|	КОГДА &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОтражениеИзлишкаПриИнкассацииДенежныхСредств) ТОГДА
	|		&СтатьяДоходов
	|	КОНЕЦ КАК СтатьяДоходовРасходов,
	|	&АналитикаДоходов КАК АналитикаДоходов,
	|	&АналитикаРасходов КАК АналитикаРасходов,
	|
	|	&Сумма КАК Сумма,
	|	&СуммаРегл КАК СуммаРегл,
	|	&СуммаВВалюте КАК СуммаВВалюте,
	|
	|	ДанныеДокумента.Касса КАК ИсточникГФУДенежныхСредств,
	|	ВЫБОР КОГДА &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОтражениеНедостачиПриИнкассацииДенежныхСредств) ТОГДА
	|		&СтатьяРасходов
	|	КОГДА &ХозяйственнаяОперация = ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ОтражениеИзлишкаПриИнкассацииДенежныхСредств) ТОГДА
	|		&СтатьяДоходов
	|	КОНЕЦ КАК ИсточникГФУДоходовРасходов
	|ИЗ
	|	Документ.ОтражениеРасхожденийПриИнкассацииДенежныхСредств КАК ДанныеДокумента
	|	
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;

КонецФункции

//++ НЕ УТ

Функция ТекстЗапросаСуммыДокументовВВалютеРегл(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "СуммыДокументовВВалютеРегл";
	
	Если НЕ ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	УстановитьПараметрыЗапросаСуммаРегл(Запрос);
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	0 КАК НомерСтроки,
	|	&Период КАК Период,
	|	&Валюта КАК Валюта,
	|	"""" КАК ИдентификаторСтроки,
	|	НЕОПРЕДЕЛЕНО КАК СтавкаНДС,
	|	Документ.Сумма КАК СуммаБезНДС,
	|	0 КАК СуммаНДС,
	|	&СуммаРегл КАК СуммаБезНДСРегл,
	|	0 КАК СуммаНДСРегл,
	|	НЕОПРЕДЕЛЕНО КАК ТипРасчетов
	|ИЗ
	|	Документ.ОтражениеРасхожденийПриИнкассацииДенежныхСредств КАК Документ
	|ГДЕ
	|	Документ.Ссылка = &Ссылка
	|	И &Валюта <> &ВалютаРегламентированногоУчета";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

//-- НЕ УТ

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	Возврат;
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

#КонецОбласти

#КонецОбласти

#КонецЕсли
