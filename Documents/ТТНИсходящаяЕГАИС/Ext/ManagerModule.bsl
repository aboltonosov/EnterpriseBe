﻿
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	ИнтеграцияЕГАИСВызовСервера.ПриПолученииФормыДокумента(
		"ТТНИсходящаяЕГАИС",
		ВидФормы,
		Параметры,
		ВыбраннаяФорма,
		ДополнительнаяИнформация,
		СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Осуществляет поиск ТТН по идентификатору ЕГАИС.
//
// Параметры:
//  ИдентификаторЕГАИС - Строка - идентификатор ТТН в системе ЕГАИС.
//
// Возвращаемое значение:
//   ДокументСсылка.ТТНИсходящаяЕГАИС - найденная ТТН. Неопределено - если не найдена.
//
Функция ТТНПоИдентификатору(ИдентификаторЕГАИС) Экспорт
	Перем Результат;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТТНИсходящаяЕГАИС.Ссылка КАК ТТН
	|ИЗ
	|	Документ.ТТНИсходящаяЕГАИС КАК ТТНИсходящаяЕГАИС
	|ГДЕ
	|	ТТНИсходящаяЕГАИС.ИдентификаторЕГАИС = &ИдентификаторЕГАИС";
	
	Запрос.УстановитьПараметр("ИдентификаторЕГАИС", ИдентификаторЕГАИС);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Результат = Выборка.ТТН;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает данные ТТН в виде структуры перед выгрузкой в УТМ.
//
// Параметры:
//  ДокументСсылка - ДокументСсылка.ТТНИсходящаяЕГАИС - выгружаемая ТТН,
//  ВидДокумента - ПеречислениеСсылка.ВидыДокументовЕГАИС - вид выгружаемого документа.
//
// Возвращаемое значение:
//   Структура - данные ТТН.
//
Функция ИнициализироватьДанныеДокументаДляВыгрузки(ДокументСсылка, ВидДокумента) Экспорт

	Если ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ТТН Тогда
		Возврат ИнициализироватьДанныеТТН(ДокументСсылка);
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ПодтверждениеАктаРасхожденийТТН
		ИЛИ ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ОтказОтАктаРасхожденийТТН
		ИЛИ ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ПодтверждениеЗапросаНаОтменуПроведенияТТН
		ИЛИ ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ОтказОтЗапросаНаОтменуПроведенияТТН Тогда
		Возврат ИнициализироватьДанныеПодтвержденияПолученногоАкта(ДокументСсылка, ВидДокумента);
		
	ИначеЕсли ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктОтказаОтТТН Тогда
		Возврат ИнициализироватьДанныеАктаОтказаОтТТН(ДокументСсылка);
		
	Иначе
		ТекстОшибки = НСтр("ru='Неподдерживаемый вид документа %1 для исходящей ТТН'");
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ВидДокумента);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
КонецФункции

// Подбирает справки Б в табличную часть товары документа по остаткам.
// 
// Параметры:
//   Объект - ДокументОбъект.ТТНИсходящаяЕГАИС - Документ-объект.
//
// Возвращаемое значение:
//  Булево - Истина, если в табличной части все справки заполнены.
//
Функция ПодобратьСправки2(Объект) Экспорт
	
	СтруктураПересчетаСуммы = ИнтеграцияЕГАИСКлиентСервер.СтруктураПересчетаСуммы("Сумма");
	
	ИнтеграцияЕГАИС.ПодобратьСправки2ДляСписанияИзРегистра1(
		Объект.Товары,
		Объект.Грузоотправитель,
		Неопределено,
		СтруктураПересчетаСуммы);
	
	Возврат ИнтеграцияЕГАИС.Справки2ЗаполненыВТабличнойЧасти(Объект.Товары);
	
КонецФункции

// СтандартныеПодсистемы.ВерсионированиеОбъектов
// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
//
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
	
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#Область Отчеты

// Заполняет список команд отчетов.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов) Экспорт
	
	ГосударственныеИнформационныеСистемыПереопределяемый.ДобавитьКомандуСтруктураПодчиненности(КомандыОтчетов);
	
	ГосударственныеИнформационныеСистемыПереопределяемый.ДобавитьКомандуДвиженияДокумента(КомандыОтчетов);
	
КонецПроцедуры

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
	
КонецПроцедуры

// Сформировать печатные формы объектов.
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую.
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать.
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати.
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы.
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов.
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных;

КонецФункции

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт
	
	////////////////////////////////////////////////////////////////////////////
	// Создадим запрос инициализации движений
	
	Запрос = Новый Запрос;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	////////////////////////////////////////////////////////////////////////////
	// Сформируем текст запроса
	
	ТекстыЗапроса = Новый СписокЗначений;
	ТекстЗапросаТаблицаОстаткиАлкогольнойПродукцииЕГАИС(Запрос, ТекстыЗапроса, Регистры);
	
	ИнтеграцияЕГАИС.ИницализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеШапки.Дата                    КАК Период,
	|	ДанныеШапки.Ссылка                  КАК Ссылка,
	|	ДанныеШапки.Грузоотправитель        КАК Грузоотправитель,
	|	ДанныеШапки.СтатусОбработки         КАК СтатусОбработки,
	|	ДанныеШапки.ДатаРегистрацииДвижений КАК ДатаРегистрацииДвижений
	|
	|ИЗ
	|	Документ.ТТНИсходящаяЕГАИС КАК ДанныеШапки
	|ГДЕ
	|	ДанныеШапки.Ссылка = &Ссылка";
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Запрос.УстановитьПараметр("Период",                  Реквизиты.Период);
	Запрос.УстановитьПараметр("ПустаяДата",              '00010101');
	Запрос.УстановитьПараметр("Ссылка",                  Реквизиты.Ссылка);
	Запрос.УстановитьПараметр("СтатусОбработки",         Реквизиты.СтатусОбработки);
	Запрос.УстановитьПараметр("СтатусыДвижений",         СтатусыДвиженийТТНИсходящей());
	Запрос.УстановитьПараметр("СтатусыРасхождений",      СтатусыРасхожденийТТНИсходящей());
	Запрос.УстановитьПараметр("Грузоотправитель",        Реквизиты.Грузоотправитель);
	Запрос.УстановитьПараметр("ДатаРегистрацииДвижений", Реквизиты.ДатаРегистрацииДвижений);
	
КонецПроцедуры

Функция ТекстЗапросаТаблицаОстаткиАлкогольнойПродукцииЕГАИС(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ОстаткиАлкогольнойПродукцииЕГАИС";
	
	Если НЕ ИнтеграцияЕГАИС.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если НЕ ИнтеграцияЕГАИС.ЕстьТаблицаЗапроса("ВТТовары", ТекстыЗапроса) Тогда
		ТекстЗапросаВТТовары(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	&Период                                КАК Период,
	|	&Грузоотправитель                      КАК ОрганизацияЕГАИС,
	|	ТаблицаТовары.АлкогольнаяПродукция     КАК АлкогольнаяПродукция,
	|	ТаблицаТовары.Справка2                 КАК Справка2,
	|	ВЫБОР
	|		КОГДА &СтатусОбработки В (&СтатусыРасхождений)
	|			ТОГДА ТаблицаТовары.КоличествоФакт
	|		ИНАЧЕ ТаблицаТовары.Количество
	|	КОНЕЦ                                  КАК СвободныйОстаток,
	|	0                                      КАК Количество,
	|	ТаблицаТовары.НомерСтроки              КАК НомерСтроки
	|ИЗ
	|	ВТТовары КАК ТаблицаТовары
	|ГДЕ
	|	&СтатусОбработки В(&СтатусыДвижений)
	|	И ВЫБОР
	|			КОГДА &СтатусОбработки В (&СтатусыРасхождений)
	|				ТОГДА ТаблицаТовары.КоличествоФакт <> 0
	|			ИНАЧЕ ТаблицаТовары.Количество <> 0
	|		КОНЕЦ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	&ДатаРегистрацииДвижений               КАК ДатаРегистрацииДвижений,
	|	&Грузоотправитель                      КАК ОрганизацияЕГАИС,
	|	ТаблицаТовары.АлкогольнаяПродукция     КАК АлкогольнаяПродукция,
	|	ТаблицаТовары.Справка2                 КАК Справка2,
	|	0                                      КАК СвободныйОстаток,
	|	ВЫБОР
	|		КОГДА &СтатусОбработки В (&СтатусыРасхождений)
	|			ТОГДА ТаблицаТовары.КоличествоФакт
	|		ИНАЧЕ ТаблицаТовары.Количество
	|	КОНЕЦ                                  КАК Количество,
	|	ТаблицаТовары.НомерСтроки              КАК НомерСтроки
	|ИЗ
	|	ВТТовары КАК ТаблицаТовары
	|ГДЕ
	|	&СтатусОбработки В (ЗНАЧЕНИЕ(Перечисление.СтатусыОбработкиТТНИсходящейЕГАИС.ПринятАктПодтверждения), ЗНАЧЕНИЕ(Перечисление.СтатусыОбработкиТТНИсходящейЕГАИС.ПереданоПодтверждениеАктаРасхождений))
	|	И &ДатаРегистрацииДвижений <> &ПустаяДата
	|	И ВЫБОР
	|			КОГДА &СтатусОбработки В (&СтатусыРасхождений)
	|				ТОГДА ТаблицаТовары.КоличествоФакт <> 0
	|			ИНАЧЕ ТаблицаТовары.Количество <> 0
	|		КОНЕЦ";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаВТТовары(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВТТовары";
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТаблицаТовары.Ссылка               КАК Ссылка,
	|	ТаблицаТовары.НомерСтроки          КАК НомерСтроки,
	|	ТаблицаТовары.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	ТаблицаТовары.Количество           КАК Количество,
	|	ТаблицаТовары.КоличествоФакт       КАК КоличествоФакт,
	|	ТаблицаТовары.Справка2             КАК Справка2
	|ПОМЕСТИТЬ ВТТовары
	|ИЗ
	|	Документ.ТТНИсходящаяЕГАИС.Товары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция СтатусыДвиженийТТНИсходящей()
	
	Результат = Новый Массив;
	Результат.Добавить(Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.ПередаетсяВЕГАИС);
	Результат.Добавить(Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.ПереданВЕГАИС);
	Результат.Добавить(Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.ПередаетсяАктОтказа);
	Результат.Добавить(Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.ОшибкаПередачиАктаОтказа);
	Результат.Добавить(Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.ПринятАктПодтверждения);
	Результат.Добавить(Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.ПринятАктРасхождений);
	Результат.Добавить(Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.ПередаетсяПодтверждениеАктаРасхождений);
	Результат.Добавить(Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.ПереданоПодтверждениеАктаРасхождений);
	Результат.Добавить(Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.ОшибкаПередачиПодтвержденияАктаРасхождений);
	Результат.Добавить(Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.ПередаетсяОтказОтАктаРасхождений);
	Результат.Добавить(Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.ОшибкаПередачиОтказаОтАктаРасхождений);
	Результат.Добавить(Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.ПринятЗапросНаОтменуПроведения);
	Результат.Добавить(Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.ПередаетсяПодтверждениеЗапросаНаОтменуПроведения);
	Результат.Добавить(Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.ПереданоПодтверждениеЗапросаНаОтменуПроведения);
	Результат.Добавить(Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.ОшибкаПередачиПодтвержденияЗапросаНаОтменуПроведения);
	Результат.Добавить(Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.ПередаетсяОтказОтЗапросаНаОтменуПроведения);
	Результат.Добавить(Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.ПереданОтказОтЗапросаНаОтменуПроведения);
	Результат.Добавить(Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.ОшибкаПередачиОтказаОтЗапросаНаОтменуПроведения);
	
	Возврат Результат;
	
КонецФункции

Функция СтатусыРасхожденийТТНИсходящей()
	
	Результат = Новый Массив;
	Результат.Добавить(Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.ПередаетсяПодтверждениеАктаРасхождений);
	Результат.Добавить(Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.ПереданоПодтверждениеАктаРасхождений);
	Результат.Добавить(Перечисления.СтатусыОбработкиТТНИсходящейЕГАИС.ОшибкаПередачиПодтвержденияАктаРасхождений);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

Функция АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра) Экспорт
	
	Запрос = Новый Запрос;
	ТекстыЗапроса = Новый СписокЗначений();
	ТекстыЗапросаВременныхТаблиц = Новый Соответствие();
	ПолноеИмяДокумента = "Документ.ТТНИсходящаяЕГАИС";
	
	Если ИмяРегистра = "ОстаткиАлкогольнойПродукцииЕГАИС" Тогда
		
		ТекстЗапроса = ТекстЗапросаТаблицаОстаткиАлкогольнойПродукцииЕГАИС(Запрос, ТекстыЗапроса, ИмяРегистра);
		ТекстыЗапросаВременныхТаблиц.Вставить("ВТТовары", ТекстЗапросаВТТовары(Запрос, ТекстыЗапроса));
		СинонимТаблицыДокумента = "ТаблицаТовары";
		
	Иначе
		ТекстИсключения = НСтр("ru = 'В документе %ПолноеИмяДокумента% не реализована адаптация текста запроса формирования движений по регистру %ИмяРегистра%.'");
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ПолноеИмяДокумента%", ПолноеИмяДокумента);
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ИмяРегистра%", ИмяРегистра);
		
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	ПереопределениеРасчетаПараметров = Новый Структура;
	
	Результат = ОбновлениеИнформационнойБазыЕГАИС.РезультатАдаптацииЗапроса();
	Результат.ЗначенияПараметров.Вставить("ПустаяДата", '00010101');
	Результат.ЗначенияПараметров.Вставить("СтатусыДвижений", СтатусыДвиженийТТНИсходящей());
	Результат.ЗначенияПараметров.Вставить("СтатусыРасхождений", СтатусыРасхожденийТТНИсходящей());
	
	Результат.ТекстЗапроса = ОбновлениеИнформационнойБазыЕГАИС.АдаптироватьЗапросМеханизмаПроведения(
		ТекстЗапроса,
		ПолноеИмяДокумента,
		СинонимТаблицыДокумента,
		ПереопределениеРасчетаПараметров,
		ТекстыЗапросаВременныхТаблиц);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает структуру, необходимую для выгрузки строки ТТН.
//
Функция СтруктураДанныхСтрокиТТНИсходящей()
	
	Результат = Новый Структура;
	Результат.Вставить("АлкогольнаяПродукция"   , Неопределено); // Элемент справочника КлассификаторАлкогольнойПродукцииЕГАИС.
	Результат.Вставить("ИдентификаторУпаковки"  , Неопределено); // Идентификатор упаковки.
	Результат.Вставить("Количество"             , 0);            // Количество продукции в ТТН.
	Результат.Вставить("Цена"                   , 0);            // Цена продукции в ТТН.
	Результат.Вставить("НомерПартии"            , Неопределено); // Номер партии продукции.
	Результат.Вставить("ИдентификаторСтроки"    , "");           // Идентификатор позиции внутри накладной.
	Результат.Вставить("НомерСправки1"          , "");           // Номер справки "А" приложения к ТТН.
	Результат.Вставить("Справка2"               , Неопределено); // Элемент справочника Справки2ЕГАИС.
	
	Возврат Результат;
	
КонецФункции

// Возвращает данные ТТН в виде структуры.
//
Функция ИнициализироватьДанныеТТН(ДокументСсылка)
	
	ДанныеТТН = ИнтеграцияЕГАИСКлиентСервер.СтруктураДанныхТТН();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТТНИсходящаяЕГАИС.Идентификатор КАК Идентификатор,
	|	ТТНИсходящаяЕГАИС.ВидОперации КАК ВидОперации,
	|	ТТНИсходящаяЕГАИС.Упакована КАК Упакована,
	|	ТТНИсходящаяЕГАИС.НомерТТН КАК НомерТТН,
	|	ТТНИсходящаяЕГАИС.ДатаТТН КАК ДатаТТН,
	|	ТТНИсходящаяЕГАИС.ДатаОтгрузки КАК ДатаОтгрузки,
	|	ТТНИсходящаяЕГАИС.Грузоотправитель КАК Грузоотправитель,
	|	ТТНИсходящаяЕГАИС.Грузополучатель КАК Грузополучатель,
	|	ТТНИсходящаяЕГАИС.Поставщик КАК Поставщик,
	|	ТТНИсходящаяЕГАИС.Основание КАК Основание,
	|	ТТНИсходящаяЕГАИС.Комментарий КАК Комментарий,
	|	ТТНИсходящаяЕГАИС.ТипДоставки КАК ТипДоставки,
	|	ТТНИсходящаяЕГАИС.Перевозчик КАК Перевозчик,
	|	ТТНИсходящаяЕГАИС.Автомобиль КАК Автомобиль,
	|	ТТНИсходящаяЕГАИС.Прицеп КАК Прицеп,
	|	ТТНИсходящаяЕГАИС.Заказчик КАК Заказчик,
	|	ТТНИсходящаяЕГАИС.Водитель КАК Водитель,
	|	ТТНИсходящаяЕГАИС.ПунктПогрузки КАК ПунктПогрузки,
	|	ТТНИсходящаяЕГАИС.ПунктРазгрузки КАК ПунктРазгрузки,
	|	ТТНИсходящаяЕГАИС.Перенаправление КАК Перенаправление,
	|	ТТНИсходящаяЕГАИС.Экспедитор КАК Экспедитор
	|ИЗ
	|	Документ.ТТНИсходящаяЕГАИС КАК ТТНИсходящаяЕГАИС
	|ГДЕ
	|	ТТНИсходящаяЕГАИС.Ссылка = &Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	ЗаполнитьЗначенияСвойств(ДанныеТТН, Выборка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТТНИсходящаяЕГАИСТовары.НомерСтроки КАК НомерСтроки,
	|	ТТНИсходящаяЕГАИСТовары.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	ТТНИсходящаяЕГАИСТовары.ИдентификаторУпаковки КАК ИдентификаторУпаковки,
	|	ТТНИсходящаяЕГАИСТовары.Количество КАК Количество,
	|	ТТНИсходящаяЕГАИСТовары.Цена КАК Цена,
	|	ТТНИсходящаяЕГАИСТовары.НомерПартии КАК НомерПартии,
	|	ТТНИсходящаяЕГАИСТовары.Справка2.НомерСправки1 КАК НомерСправки1,
	|	ТТНИсходящаяЕГАИСТовары.Справка2 КАК Справка2
	|ИЗ
	|	Документ.ТТНИсходящаяЕГАИС.Товары КАК ТТНИсходящаяЕГАИСТовары
	|ГДЕ
	|	ТТНИсходящаяЕГАИСТовары.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СтрокаТТН = СтруктураДанныхСтрокиТТНИсходящей();
		ЗаполнитьЗначенияСвойств(СтрокаТТН, Выборка);
		СтрокаТТН.ИдентификаторСтроки = Формат(Выборка.НомерСтроки, "ЧГ=0");
		
		ДанныеТТН.ТаблицаТоваров.Добавить(СтрокаТТН);
	КонецЦикла;
	
	Возврат ДанныеТТН;
	
КонецФункции

// Возвращает данные подтверждения акта в виде структуры.
//
Функция ИнициализироватьДанныеПодтвержденияПолученногоАкта(ДокументСсылка, ВидДокумента)
	
	ОтказОтАкта = ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ОтказОтАктаРасхожденийТТН
		ИЛИ ВидДокумента = Перечисления.ВидыДокументовЕГАИС.ОтказОтЗапросаНаОтменуПроведенияТТН;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.УстановитьПараметр("Отказ", ОтказОтАкта);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	&Отказ КАК Отказ,
	|	ТТНИсходящаяЕГАИС.Номер КАК Номер,
	|	ТТНИсходящаяЕГАИС.ИдентификаторЕГАИС КАК ИдентификаторЕГАИС,
	|	ТТНИсходящаяЕГАИС.Комментарий КАК Комментарий
	|ИЗ
	|	Документ.ТТНИсходящаяЕГАИС КАК ТТНИсходящаяЕГАИС
	|ГДЕ
	|	ТТНИсходящаяЕГАИС.Ссылка = &Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	ДанныеДляВыгрузки = СтруктураДанныхПодтвержденияПолученногоАкта();
	ЗаполнитьЗначенияСвойств(ДанныеДляВыгрузки, Выборка);
	
	Возврат ДанныеДляВыгрузки;
	
КонецФункции

// Возвращает данные акта отказа от ТТН.
//
Функция ИнициализироватьДанныеАктаОтказаОтТТН(ДокументСсылка)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТТНИсходящаяЕГАИС.Номер КАК Номер,
	|	ИСТИНА КАК Отказ,
	|	ТТНИсходящаяЕГАИС.ИдентификаторЕГАИС КАК ИдентификаторЕГАИС,
	|	ТТНИсходящаяЕГАИС.Комментарий КАК Комментарий
	|ИЗ
	|	Документ.ТТНИсходящаяЕГАИС КАК ТТНИсходящаяЕГАИС
	|ГДЕ
	|	ТТНИсходящаяЕГАИС.Ссылка = &Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	ДанныеАкта = ИнтеграцияЕГАИСКлиентСервер.СтруктураДанныхАктаПодтвержденияТТН();
	ЗаполнитьЗначенияСвойств(ДанныеАкта, Выборка);
	ДанныеАкта.Идентификатор = Строка(ДокументСсылка.УникальныйИдентификатор());
	
	Возврат ДанныеАкта;
	
КонецФункции

// Возвращает структуру, необходимую для выгрузки подтверждения (отказа) полученного акта.
//
Функция СтруктураДанныхПодтвержденияПолученногоАкта()
	
	Результат = Новый Структура;
	Результат.Вставить("Идентификатор"     , "");   // Идентификатор документа (клиентский, к заполнению необязательный).
	Результат.Вставить("Отказ"             , Ложь); // Признак отказа от полученного акта.
	Результат.Вставить("Номер"             , "");   // Номер подтверждения.
	Результат.Вставить("ИдентификаторЕГАИС", "");   // Идентификатор ТТН в системе ЕГАИС.
	Результат.Вставить("Комментарий"       , "");   // Примечание.
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли