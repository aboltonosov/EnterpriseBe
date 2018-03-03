﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Заполняет список команд создания на основании.
// 
// Параметры:
//   КомандыСоздатьНаОсновании - ТаблицаЗначений - состав полей см. в функции ВводНаОсновании.СоздатьКоллекциюКомандСоздатьНаОсновании
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСоздатьНаОсновании) Экспорт
	
	Обработки.ПомощникОформленияСкладскихАктов.ДобавитьКомандуСоздатьНаОснованииПомощникОформленияСкладскихАктов(КомандыСоздатьНаОсновании);
	
	Документы.СписаниеНедостачТоваров.ДобавитьКомандуСоздатьНаОсновании(КомандыСоздатьНаОсновании);
	
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

	 
	Если ПравоДоступа("Добавление", Метаданные.Документы.ОрдерНаОтражениеНедостачТоваров) Тогда
		КомандаСоздатьНаОсновании = КомандыСоздатьНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Идентификатор = Метаданные.Документы.ОрдерНаОтражениеНедостачТоваров.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ВводНаОсновании.ПредставлениеОбъекта(Метаданные.Документы.ОрдерНаОтражениеНедостачТоваров);
		КомандаСоздатьНаОсновании.ПроверкаПроведенияПередСозданиемНаОсновании = Истина;
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач";
	

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

	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуДвиженияДокумента(КомандыОтчетов);

	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуОформление(КомандыОтчетов);

КонецПроцедуры


//Имена реквизитов, от значений которых зависят параметры указания серий
//
//	Возвращаемое значение:
//		Строка - имена реквизитов, перечисленные через запятую
//
Функция ИменаРеквизитовДляЗаполненияПараметровУказанияСерий() Экспорт
	
	ИменаРеквизитов = "Склад,Помещение,Дата";
	Возврат ИменаРеквизитов;
	
КонецФункции

// Возвращает параметры указания серий для товаров, указанных в документе.
//
// Параметры:
//  Объект	 - Структура - структура значений реквизитов объекта, необходимых для заполнения параметров указания серий.
// 
// Возвращаемое значение:
//  Структура - состав полей задается в функции ОбработкаТабличнойЧастиКлиентСервер.ПараметрыУказанияСерий.
//
Функция ПараметрыУказанияСерий(Объект) Экспорт
	
	ПараметрыСерийСклада = СкладыСервер.ИспользованиеСерийНаСкладе(Объект.Склад, Ложь);
	
	ПараметрыУказанияСерий = НоменклатураКлиентСервер.ПараметрыУказанияСерий();
	ПараметрыУказанияСерий.ПолноеИмяОбъекта = "Документ.ОрдерНаОтражениеНедостачТоваров";
	ПараметрыУказанияСерий.ИспользоватьСерииНоменклатуры = ПараметрыСерийСклада.ИспользоватьСерииНоменклатуры;
	ПараметрыУказанияСерий.УчитыватьСебестоимостьПоСериям = ПараметрыСерийСклада.УчитыватьСебестоимостьПоСериям;
	ПараметрыУказанияСерий.СкладскиеОперации.Добавить(Перечисления.СкладскиеОперации.ОтражениеНедостач);
	ПараметрыУказанияСерий.ИспользоватьАдресноеХранение = СкладыСервер.ИспользоватьАдресноеХранение(
		Объект.Склад,Объект.Помещение, Объект.Дата);
	
	Если ПараметрыУказанияСерий.ИспользоватьАдресноеХранение Тогда
		ПараметрыУказанияСерий.ПоляСвязи.Добавить("Ячейка");
		ПараметрыУказанияСерий.ПоляСвязи.Добавить("Упаковка");
		ПараметрыУказанияСерий.ИмяПоляКоличество = "КоличествоУпаковок";	
	КонецЕсли;
	
	ПараметрыУказанияСерий.ПоляСвязи.Добавить("Назначение");
	
	ПараметрыУказанияСерий.ЭтоОрдер = Истина;
	ПараметрыУказанияСерий.ИмяТЧСерии = "Товары";
	ПараметрыУказанияСерий.ИмяПоляПомещение = "Помещение";
	ПараметрыУказанияСерий.Дата = Объект.Дата;
	
	Возврат ПараметрыУказанияСерий;
	
КонецФункции

// Возвращает текст запроса для расчета статусов указания серий.
//
//	Параметры:
//		ПараметрыУказанияСерий - Структура - состав полей задается в функции НоменклатураКлиентСервер.ПараметрыУказанияСерий
//
//	Возвращаемое значение:
//		Строка - текст запроса.
//
Функция ТекстЗапросаЗаполненияСтатусовУказанияСерий(ПараметрыУказанияСерий) Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.Серия КАК Серия,
	|	Товары." + ПараметрыУказанияСерий.ИмяПоляКоличество + " КАК Количество,
	|	Товары.СтатусУказанияСерий КАК СтатусУказанияСерий
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	&Товары КАК Товары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	Товары.Номенклатура КАК Номенклатура,
	|	ВЫРАЗИТЬ(Товары.Номенклатура КАК Справочник.Номенклатура).ВидНоменклатуры КАК ВидНоменклатуры,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.Серия КАК Серия,
	|	Товары.Количество КАК Количество,
	|	Товары.СтатусУказанияСерий КАК СтатусУказанияСерий
	|ПОМЕСТИТЬ ТоварыДляЗапроса
	|ИЗ
	|	Товары КАК Товары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Товары.НомерСтроки КАК НомерСтроки,
	|	Товары.СтатусУказанияСерий КАК СтарыйСтатусУказанияСерий,
	|	ВЫБОР
	|		КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий ЕСТЬ NULL 
	|			ТОГДА 0
	|		ИНАЧЕ ВЫБОР
	|				КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УчитыватьСебестоимостьПоСериям
	|					ТОГДА ВЫБОР
	|							КОГДА Товары.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|								ТОГДА 14
	|							ИНАЧЕ 13
	|						КОНЕЦ
	|				КОГДА НЕ &ТолькоСерииДляСебестоимости
	|					ТОГДА ВЫБОР
	|							КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПланированииОтгрузки
	|								ТОГДА ВЫБОР
	|										КОГДА Товары.Количество > 0
	|											ТОГДА 10
	|										ИНАЧЕ 9
	|									КОНЕЦ
	|							КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПланированииОтбора
	|								ТОГДА ВЫБОР
	|										КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УчетСерийПоFEFO
	|											ТОГДА ВЫБОР
	|													КОГДА Товары.Количество > 0
	|														ТОГДА 6
	|													ИНАЧЕ 5
	|												КОНЕЦ
	|										ИНАЧЕ ВЫБОР
	|												КОГДА Товары.Количество > 0
	|													ТОГДА 8
	|												ИНАЧЕ 7
	|											КОНЕЦ
	|									КОНЕЦ
	|							КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПоФактуОтбора
	|								ТОГДА ВЫБОР
	|										КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УчитыватьОстаткиСерий
	|											ТОГДА ВЫБОР
	|													КОГДА Товары.Количество > 0
	|														ТОГДА 4
	|													ИНАЧЕ 3
	|												КОНЕЦ
	|										ИНАЧЕ ВЫБОР
	|												КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриОтраженииНедостач
	|													ТОГДА ВЫБОР
	|															КОГДА Товары.Количество > 0
	|																ТОГДА 2
	|															ИНАЧЕ 1
	|														КОНЕЦ
	|												ИНАЧЕ 0
	|											КОНЕЦ
	|									КОНЕЦ
	|							ИНАЧЕ 0
	|						КОНЕЦ
	|			КОНЕЦ
	|	КОНЕЦ КАК СтатусУказанияСерий
	|ПОМЕСТИТЬ Статусы
	|ИЗ
	|	ТоварыДляЗапроса КАК Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры.ПолитикиУчетаСерий КАК ПолитикиУчетаСерий
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Склады КАК Склады
	|			ПО (&Склад = Склады.Ссылка)
	|		ПО (ПолитикиУчетаСерий.Склад = &Склад)
	|			И Товары.ВидНоменклатуры = ПолитикиУчетаСерий.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Статусы.НомерСтроки КАК НомерСтроки,
	|	Статусы.СтатусУказанияСерий КАК СтатусУказанияСерий
	|ИЗ
	|	Статусы КАК Статусы
	|ГДЕ
	|	Статусы.СтатусУказанияСерий <> Статусы.СтарыйСтатусУказанияСерий
	|
	|УПОРЯДОЧИТЬ ПО
	|	Статусы.НомерСтроки";
	
	Возврат ТекстЗапроса;
	
КонецФункции

// Инициализирует параметры, обслуживающие выбор назначений в формах документа.
// 
//  Возвращаемое значение:
//  Структура - структура параметров, см. Справочники.Назначения.МакетФормыВыбораНазначений().
//
Функция МакетФормыВыбораНазначений() Экспорт
	
	МакетФормы = Справочники.Назначения.МакетФормыВыбораНазначений();
	
	ШаблонНазначения = Справочники.Назначения.ДобавитьШаблонНазначений(МакетФормы);
	ШаблонНазначения.ДвиженияПоСкладскимРегистрам = "ИСТИНА";
	
	// Остатки товаров на складе.
	ОписаниеКолонок = Справочники.Назначения.ДобавитьОписаниеКолонок(МакетФормы, "ОбеспечениеЗаказов", Истина, "Объект.Товары.Назначение");
	ОписаниеКолонок.Колонки.НайтиПоЗначению("ВНаличии").Пометка = Истина;
	ОписаниеКолонок.КолонкиПоУмолчанию.Добавить("ВНаличии");
	
	ОписаниеКолонок.ПутиКДанным.Номенклатура     = "Объект.Товары.Номенклатура";
	ОписаниеКолонок.ПутиКДанным.Характеристика   = "Объект.Товары.Характеристика";
	ОписаниеКолонок.ПутиКДанным.Склад            = "Объект.Склад";
	
	Возврат МакетФормы;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт

	ИсточникиДанных = Новый Соответствие;

	Возврат ИсточникиДанных; 

КонецФункции

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, ДополнительныеСвойства, Регистры = Неопределено) Экспорт

	Запрос = Новый Запрос;
	
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	ТекстыЗапроса = Новый СписокЗначений;
	
	ТекстЗапросаТаблицаТоварыКОформлениюИзлишковНедостач(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаТоварыНаСкладах(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаСвободныеОстатки(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаТоварыВЯчейках(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаДвиженияСерийТоваров(Запрос, ТекстыЗапроса, Регистры);
	ТекстЗапросаТаблицаОбеспечениеЗаказов(Запрос, ТекстыЗапроса, Регистры);
	
	ПроведениеСерверУТ.ИницализироватьТаблицыДляДвижений(Запрос, ТекстыЗапроса, ДополнительныеСвойства.ТаблицыДляДвижений, Истина);
	
КонецПроцедуры

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДанныеШапки.Дата КАК Период,
	|	ДанныеШапки.Склад КАК Склад,
	|	ДанныеШапки.Помещение КАК Помещение,
	|	ДанныеШапки.Ссылка КАК Ссылка,
	|	ВЫБОР
	|		КОГДА ДанныеШапки.Склад.ИспользоватьСкладскиеПомещения
	|				И ДанныеШапки.Дата >= ДанныеШапки.Склад.ДатаНачалаИспользованияСкладскихПомещений
	|			ТОГДА ВЫБОР
	|					КОГДА ДанныеШапки.Помещение.ИспользоватьАдресноеХранение
	|							И ДанныеШапки.Дата >= ДанныеШапки.Помещение.ДатаНачалаАдресногоХраненияОстатков
	|						ТОГДА ИСТИНА
	|					ИНАЧЕ ЛОЖЬ
	|				КОНЕЦ
	|		ИНАЧЕ ВЫБОР
	|				КОГДА ДанныеШапки.Склад.ИспользоватьАдресноеХранение
	|						И ДанныеШапки.Дата >= ДанныеШапки.Склад.ДатаНачалаАдресногоХраненияОстатков
	|					ТОГДА ИСТИНА
	|				ИНАЧЕ ЛОЖЬ
	|			КОНЕЦ
	|	КОНЕЦ КАК ИспользоватьАдресноеХранение
	|ИЗ
	|	Документ.ОрдерНаОтражениеНедостачТоваров КАК ДанныеШапки
	|ГДЕ
	|	ДанныеШапки.Ссылка = &Ссылка";
	Реквизиты = Запрос.Выполнить().Выбрать();
	Реквизиты.Следующий();
	
	Запрос.УстановитьПараметр("Период",            Реквизиты.Период);
	Запрос.УстановитьПараметр("Склад",             Реквизиты.Склад);
	Запрос.УстановитьПараметр("Помещение",         Реквизиты.Помещение);
	Запрос.УстановитьПараметр("ИспользоватьАдресноеХранение", Реквизиты.ИспользоватьАдресноеХранение);
	
КонецПроцедуры

Функция ТекстЗапросаТаблицаТоварыКОформлениюИзлишковНедостач(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ТоварыКОформлениюИзлишковНедостач";
	
	Если Не ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если НЕ ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтТаблицаТовары", ТекстыЗапроса) Тогда
		ТекстЗапросаВтТаблицаТовары(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТаблицаТовары.Номенклатура,
	|	ТаблицаТовары.Характеристика,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ТаблицаТовары.Назначение.ДвиженияПоСкладскимРегистрам, ЛОЖЬ)
	|			ТОГДА ТаблицаТовары.Назначение
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|	КОНЕЦ КАК Назначение,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.СтатусУказанияСерий = 14
	|			ТОГДА ТаблицаТовары.Серия
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ КАК Серия,
	|	ТаблицаТовары.Количество КАК КОформлениюАктов,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	&Период КАК Период,
	|	&Склад КАК Склад
	|ИЗ
	|	ВтТаблицаТовары КАК ТаблицаТовары";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);

	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаТоварыНаСкладах(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ТоварыНаСкладах";
	
	Если Не ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если НЕ ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтТаблицаТовары", ТекстыЗапроса) Тогда
		ТекстЗапросаВтТаблицаТовары(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТаблицаТовары.Номенклатура,
	|	ТаблицаТовары.Характеристика,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ТаблицаТовары.Назначение.ДвиженияПоСкладскимРегистрам, ЛОЖЬ)
	|			ТОГДА ТаблицаТовары.Назначение
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|	КОНЕЦ КАК Назначение,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.СтатусУказанияСерий В (4, 6, 8, 10, 14)
	|			ТОГДА ТаблицаТовары.Серия
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ КАК Серия,
	|	ТаблицаТовары.Количество КАК ВНаличии,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	&Период КАК Период,
	|	&Склад КАК Склад,
	|	&Помещение КАК Помещение
	|ИЗ
	|	ВтТаблицаТовары КАК ТаблицаТовары";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);

	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаСвободныеОстатки(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "СвободныеОстатки";
	
	Если Не ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если НЕ ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтТаблицаТовары", ТекстыЗапроса) Тогда
		ТекстЗапросаВтТаблицаТовары(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТаблицаТовары.Номенклатура,
	|	ТаблицаТовары.Характеристика,
	|	ТаблицаТовары.Количество КАК ВНаличии,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.Назначение <> ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|			ТОГДА ТаблицаТовары.Количество
	|	КОНЕЦ КАК ВРезервеПодЗаказ,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	&Период КАК Период,
	|	&Склад КАК Склад,
	|	&Помещение КАК Помещение
	|ИЗ
	|	ВтТаблицаТовары КАК ТаблицаТовары";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);

	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаТоварыВЯчейках(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ТоварыВЯчейках";
	
	Если Не ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли; 
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТаблицаТовары.Номенклатура КАК Номенклатура,
	|	ТаблицаТовары.Характеристика КАК Характеристика,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ТаблицаТовары.Назначение.ДвиженияПоСкладскимРегистрам, ЛОЖЬ)
	|			ТОГДА ТаблицаТовары.Назначение
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|	КОНЕЦ КАК Назначение,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.СтатусУказанияСерий В (4, 6, 8, 10, 14)
	|			ТОГДА ТаблицаТовары.Серия
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|	КОНЕЦ КАК Серия,
	|	ТаблицаТовары.Ячейка КАК Ячейка,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.Упаковка.ТипИзмеряемойВеличины = ЗНАЧЕНИЕ(Перечисление.ТипыИзмеряемыхВеличин.Упаковка)
	|			ТОГДА ТаблицаТовары.Упаковка
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
	|	КОНЕЦ КАК Упаковка,
	|	ВЫБОР
	|		КОГДА ТаблицаТовары.Упаковка.ТипИзмеряемойВеличины = ЗНАЧЕНИЕ(Перечисление.ТипыИзмеряемыхВеличин.Упаковка)
	|			ТОГДА ТаблицаТовары.КоличествоУпаковок
	|		ИНАЧЕ ТаблицаТовары.Количество
	|	КОНЕЦ КАК ВНаличии,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	&Период КАК Период
	|ИЗ
	|	Документ.ОрдерНаОтражениеНедостачТоваров.Товары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Ссылка = &Ссылка
	|	И &ИспользоватьАдресноеХранение";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);

	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаДвиженияСерийТоваров(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДвиженияСерийТоваров";
	
	Если Не ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если НЕ ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтТаблицаТовары", ТекстыЗапроса) Тогда
		ТекстЗапросаВтТаблицаТовары(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТаблицаСерии.Номенклатура КАК Номенклатура,
	|	ТаблицаСерии.Характеристика КАК Характеристика,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ТаблицаСерии.Назначение.ДвиженияПоСкладскимРегистрам, ЛОЖЬ)
	|			ТОГДА ТаблицаСерии.Назначение
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
	|	КОНЕЦ КАК Назначение,
	|	ТаблицаСерии.Серия КАК Серия,
	|	ТаблицаСерии.Количество КАК Количество,
	|	&Склад КАК Отправитель,
	|	&Помещение КАК ПомещениеОтправителя,
	|	ЗНАЧЕНИЕ(Перечисление.СкладскиеОперации.ОтражениеНедостач) КАК СкладскаяОперация,
	|	&Ссылка КАК Документ,
	|	&Период КАК Период
	|ИЗ
	|	ВтТаблицаТовары КАК ТаблицаСерии
	|ГДЕ
	|	ТаблицаСерии.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);

	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаОбеспечениеЗаказов(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ОбеспечениеЗаказов";
	
	Если Не ПроведениеСерверУТ.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	Если НЕ ПроведениеСерверУТ.ЕстьТаблицаЗапроса("ВтТаблицаТовары", ТекстыЗапроса) Тогда
		ТекстЗапросаВтТаблицаТовары(Запрос, ТекстыЗапроса);
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	&Период                      КАК Период,
	|	ТаблицаТовары.Номенклатура   КАК Номенклатура,
	|	ТаблицаТовары.Характеристика КАК Характеристика,
	|	&Склад          			 КАК Склад,
	|	ТаблицаТовары.Назначение     КАК Назначение,
	|	-ТаблицаТовары.Количество 	 КАК КЗаказу,
	|	ТаблицаТовары.Количество 	 КАК НаличиеПодЗаказ
	|ИЗ
	|	ВтТаблицаТовары КАК ТаблицаТовары
	|ГДЕ
	|	ТаблицаТовары.Назначение <> ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)	
	|	И ТаблицаТовары.Количество <> 0";
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);

	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

	// Отражение недостач товаров
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ОрдерНаОтражениеНедостачТоваров";
	КомандаПечати.Представление = НСтр("ru = 'Отражение недостач товаров'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;

КонецПроцедуры

Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ОрдерНаОтражениеНедостачТоваров") Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"ОрдерНаОтражениеНедостачТоваров",
			НСтр("ru = 'Отражение недостач товаров'"),
			ПечатьОтраженияНедостачТоваровНаСкладе(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
КонецПроцедуры

Функция ПечатьОтраженияНедостачТоваровНаСкладе(МассивОбъектов, ОбъектыПечати)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ОрдерНаОтражениеНедостачТоваров_ОтражениеНедостачТоваров";
	
	КолонкаКодов = ФормированиеПечатныхФорм.ИмяДополнительнойКолонки();
	ВыводитьКоды = ЗначениеЗаполнено(КолонкаКодов);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОрдерНаОтражениеНедостачТоваров.Ссылка,
	|	ПРЕДСТАВЛЕНИЕ(ОрдерНаОтражениеНедостачТоваров.Склад) КАК СкладПредставление,
	|	ОрдерНаОтражениеНедостачТоваров.Дата,
	|	ОрдерНаОтражениеНедостачТоваров.Номер,
	|	ВЫБОР
	|		КОГДА ОрдерНаОтражениеНедостачТоваров.Склад.ИспользоватьСкладскиеПомещения
	|			ТОГДА ОрдерНаОтражениеНедостачТоваров.Помещение.ТекущийОтветственный
	|		ИНАЧЕ ОрдерНаОтражениеНедостачТоваров.Склад.ТекущийОтветственный
	|	КОНЕЦ КАК Кладовщик,
	|	ВЫБОР
	|		КОГДА ОрдерНаОтражениеНедостачТоваров.Склад.ИспользоватьСкладскиеПомещения
	|			ТОГДА ОрдерНаОтражениеНедостачТоваров.Помещение.ТекущаяДолжностьОтветственного
	|		ИНАЧЕ ОрдерНаОтражениеНедостачТоваров.Склад.ТекущаяДолжностьОтветственного
	|	КОНЕЦ КАК КладовщикДолжность,
	|	ОрдерНаОтражениеНедостачТоваров.Ответственный.ФизическоеЛицо КАК Ответственный,
	|	ОрдерНаОтражениеНедостачТоваров.Склад КАК Склад,
	|	ВЫБОР
	|		КОГДА ОрдерНаОтражениеНедостачТоваров.Склад.ИспользоватьСкладскиеПомещения
	|				И ОрдерНаОтражениеНедостачТоваров.Дата >= ОрдерНаОтражениеНедостачТоваров.Склад.ДатаНачалаИспользованияСкладскихПомещений
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ИспользоватьСкладскиеПомещения,
	|	ПРЕДСТАВЛЕНИЕ(ОрдерНаОтражениеНедостачТоваров.Помещение) КАК ПомещениеПредставление,
	|	ОрдерНаОтражениеНедостачТоваров.Помещение КАК Помещение
	|ИЗ
	|	Документ.ОрдерНаОтражениеНедостачТоваров КАК ОрдерНаОтражениеНедостачТоваров
	|ГДЕ
	|	ОрдерНаОтражениеНедостачТоваров.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	ОрдерНаОтражениеНедостачТоваров.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОрдерНаОтражениеНедостачТоваров.Ссылка КАК Ссылка,
	|	ОрдерНаОтражениеНедостачТоваров.НомерСтроки КАК НомерСтроки,
	|   ПРЕДСТАВЛЕНИЕ(ОрдерНаОтражениеНедостачТоваров.Ячейка) КАК ЯчейкаПредставление,
	|	ОрдерНаОтражениеНедостачТоваров.Номенклатура.НаименованиеПолное КАК ПредставлениеНоменклатуры,
	|	" + ?(ВыводитьКоды, "ОрдерНаОтражениеНедостачТоваров.Номенклатура." + КолонкаКодов +" КАК ДопКолонка,", "") + "
	|	ОрдерНаОтражениеНедостачТоваров.Характеристика.НаименованиеПолное КАК ПредставлениеХарактеристики,
	|	ОрдерНаОтражениеНедостачТоваров.Серия.Наименование КАК ПредставлениеСерии,
	|	ОрдерНаОтражениеНедостачТоваров.КоличествоУпаковок КАК КоличествоУпаковок,
	|	ОрдерНаОтражениеНедостачТоваров.Количество КАК Количество,
	|	ПРЕДСТАВЛЕНИЕ(ОрдерНаОтражениеНедостачТоваров.Номенклатура.ЕдиницаИзмерения) КАК ПредставлениеБазовойЕдиницыИзмерения,
	|	ВЫБОР
	|		КОГДА ОрдерНаОтражениеНедостачТоваров.Упаковка <> ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
	|			ТОГДА ПРЕДСТАВЛЕНИЕ(ОрдерНаОтражениеНедостачТоваров.Упаковка)
	|		ИНАЧЕ ПРЕДСТАВЛЕНИЕ(ОрдерНаОтражениеНедостачТоваров.Номенклатура.ЕдиницаИзмерения)
	|	КОНЕЦ КАК ПредставлениеЕдининицыИзмеренияУпаковки
	|ИЗ
	|	Документ.ОрдерНаОтражениеНедостачТоваров.Товары КАК ОрдерНаОтражениеНедостачТоваров
	|ГДЕ
	|	ОрдерНаОтражениеНедостачТоваров.Ссылка В(&МассивОбъектов)
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ссылка,
	|	НомерСтроки
	|ИТОГИ ПО
	|	Ссылка";
	
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	
	Результаты = Запрос.ВыполнитьПакет();
	
	ВыборкаПоДокументам = Результаты[0].Выбрать();
	ВыборкаПоТабличнымЧастям = Результаты[1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ПервыйДокумент = Истина;
	
	РеквизитыДокумента = Новый Структура("Номер, Дата, Префикс");
	
	СинонимДокумента = "";
	
	Пока ВыборкаПоДокументам.Следующий() Цикл
		
		Если НЕ ВыборкаПоТабличнымЧастям.НайтиСледующий(Новый Структура("Ссылка",ВыборкаПоДокументам.Ссылка)) Тогда
			Продолжить;
		КонецЕсли;
		
		ВыводитьЯчейкиИУпаковки = СкладыСервер.ИспользоватьАдресноеХранение(ВыборкаПоДокументам.Склад, ВыборкаПоДокументам.Помещение, ВыборкаПоДокументам.Дата);
		
		//Макет получаем в цикле,т.к. ширина колонок зависит от склада и помещения в документе
		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.ОрдерНаОтражениеНедостачТоваров.ПФ_MXL_ОрдерНаОтражениеНедостачТоваров");
		
		ОбластьЗаголовок 		= Макет.ПолучитьОбласть("Заголовок");
		ОбластьШапка 			= Макет.ПолучитьОбласть("Шапка");
		
		ОбластьШапкаТаблицыНачало 	= Макет.ПолучитьОбласть("ШапкаТаблицы|НачалоСтроки");
		ОбластьСтрокаТаблицыНачало 	= Макет.ПолучитьОбласть("СтрокаТаблицы|НачалоСтроки");
		ОбластьПодвалТаблицыНачало 	= Макет.ПолучитьОбласть("ПодвалТаблицы|НачалоСтроки");
		
		Если ВыводитьЯчейкиИУпаковки Тогда
			ОбластьШапкаТаблицыКолонкаКодов 	= Макет.ПолучитьОбласть("ШапкаТаблицы|КолонкаКодов");
			ОбластьСтрокаТаблицыКолонкаКодов 	= Макет.ПолучитьОбласть("СтрокаТаблицы|КолонкаКодов");
			ОбластьПодвалТаблицыКолонкаКодов 	= Макет.ПолучитьОбласть("ПодвалТаблицы|КолонкаКодов");
			
			ОбластьШапкаТаблицыЯчейка	= Макет.ПолучитьОбласть("ШапкаТаблицы|Ячейка");
			ОбластьСтрокаТаблицыЯчейка	= Макет.ПолучитьОбласть("СтрокаТаблицы|Ячейка");
			ОбластьПодвалТаблицыЯчейка	= Макет.ПолучитьОбласть("ПодвалТаблицы|Ячейка");
			
			ОбластьШапкаТаблицыКолонкаУпаковок 		= Макет.ПолучитьОбласть("ШапкаТаблицы|КолонкаУпаковок");
			ОбластьСтрокаТаблицыКолонкаУпаковок 	= Макет.ПолучитьОбласть("СтрокаТаблицы|КолонкаУпаковок");
			ОбластьПодвалТаблицыКолонкаУпаковок		= Макет.ПолучитьОбласть("ПодвалТаблицы|КолонкаУпаковок");
			
			ОбластьШапкаТаблицыКолонкаТоваров 	= Макет.ПолучитьОбласть("ШапкаТаблицы|КолонкаТоваров");
			ОбластьСтрокаТаблицыКолонкаТоваров 	= Макет.ПолучитьОбласть("СтрокаТаблицы|КолонкаТоваров");
			ОбластьПодвалТаблицыКолонкаТоваров 	= Макет.ПолучитьОбласть("ПодвалТаблицы|КолонкаТоваров");
		Иначе
			ОбластьШапкаТаблицыКолонкаКодов 	= Макет.ПолучитьОбласть("ШапкаТаблицыБезЯчУп|КолонкаКодовБезЯчейки");
			ОбластьСтрокаТаблицыКолонкаКодов 	= Макет.ПолучитьОбласть("СтрокаТаблицыБезЯчУп|КолонкаКодовБезЯчейки");
			ОбластьПодвалТаблицыКолонкаКодов 	= Макет.ПолучитьОбласть("ПодвалТаблицы|КолонкаКодовБезЯчейки");
			
			ОбластьШапкаТаблицыКолонкаТоваров 	= Макет.ПолучитьОбласть("ШапкаТаблицыБезЯчУп|ТоварБезУпаковок");
			ОбластьСтрокаТаблицыКолонкаТоваров 	= Макет.ПолучитьОбласть("СтрокаТаблицыБезЯчУп|ТоварБезУпаковок");
			ОбластьПодвалТаблицыКолонкаТоваров 	= Макет.ПолучитьОбласть("ПодвалТаблицы|ТоварБезУпаковок");
		КонецЕсли;
		
		ОбластьШапкаТаблицыКолонкаКодов.Параметры.ИмяКолонкиКодов = КолонкаКодов; 
		ОбластьПодписей = Макет.ПолучитьОбласть("Подписи");
		
		ОбластьКолонкаТоваров = ?(ВыводитьЯчейкиИУпаковки, Макет.Область("КолонкаТоваров"), Макет.Область("ТоварБезУпаковок"));
		
		Если НЕ ВыводитьКоды Тогда
			ОбластьКолонкаТоваров.ШиринаКолонки = ОбластьКолонкаТоваров.ШиринаКолонки 
					+ ?(ВыводитьЯчейкиИУпаковки, Макет.Область("КолонкаКодов").ШиринаКолонки, Макет.Область("КолонкаКодовБезЯчейки").ШиринаКолонки); 
		КонецЕсли;
		
		ОбластьШапкаТаблицыКонец 	= Макет.ПолучитьОбласть("ШапкаТаблицы|КонецСтроки");
		ОбластьСтрокаТаблицыКонец 	= Макет.ПолучитьОбласть("СтрокаТаблицы|КонецСтроки");
		ОбластьПодвалТаблицыКонец 	= Макет.ПолучитьОбласть("ПодвалТаблицы|КонецСтроки");
		
		ВыборкаПоСтрокамТЧ = ВыборкаПоТабличнымЧастям.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ЗаполнитьЗначенияСвойств(РеквизитыДокумента,ВыборкаПоДокументам);
		
		Если Не ЗначениеЗаполнено(СинонимДокумента) Тогда
			МетаданныеДокумента = ВыборкаПоДокументам.Ссылка.Метаданные();
			Если Не ЗначениеЗаполнено(МетаданныеДокумента.ПредставлениеОбъекта) Тогда
				СинонимДокумента = МетаданныеДокумента.Синоним;
			Иначе
				СинонимДокумента = МетаданныеДокумента.ПредставлениеОбъекта;
			КонецЕсли;
		КонецЕсли;
		
		Заголовок = ОбщегоНазначенияУТКлиентСервер.СформироватьЗаголовокДокумента(РеквизитыДокумента, СинонимДокумента);
		
		ОбластьЗаголовок.Параметры.ТекстЗаголовка = Заголовок;
		
		ШтрихкодированиеПечатныхФорм.ВывестиШтрихкодВТабличныйДокумент(ТабличныйДокумент, Макет, ОбластьЗаголовок, ВыборкаПоДокументам.Ссылка);
		ТабличныйДокумент.Вывести(ОбластьЗаголовок);
		
		ОбластьШапка.Параметры.Заполнить(ВыборкаПоДокументам);
		
		ОбластьШапка.Параметры.СкладПредставление = СкладыСервер.ПолучитьПредставлениеСклада(
			ВыборкаПоДокументам.СкладПредставление,
			ВыборкаПоДокументам.ПомещениеПредставление);
		
		ТабличныйДокумент.Вывести(ОбластьШапка);
		
		ТабличныйДокумент.Вывести(ОбластьШапкаТаблицыНачало);
		
		Если ВыводитьЯчейкиИУпаковки Тогда
			ТабличныйДокумент.Присоединить(ОбластьШапкаТаблицыЯчейка);
		КонецЕсли;
		Если ВыводитьКоды Тогда
			ТабличныйДокумент.Присоединить(ОбластьШапкаТаблицыКолонкаКодов);
		КонецЕсли;
		
		ТабличныйДокумент.Присоединить(ОбластьШапкаТаблицыКолонкаТоваров);
		
		Если ВыводитьЯчейкиИУпаковки Тогда
			ТабличныйДокумент.Присоединить(ОбластьШапкаТаблицыКолонкаУпаковок);
		КонецЕсли;
		
		ТабличныйДокумент.Присоединить(ОбластьШапкаТаблицыКонец);
		
		Пока ВыборкаПоСтрокамТЧ.Следующий() Цикл
			
			ОбластьСтрокаТаблицыНачало.Параметры.Заполнить(ВыборкаПоСтрокамТЧ);
			ТабличныйДокумент.Вывести(ОбластьСтрокаТаблицыНачало);
			
			Если ВыводитьЯчейкиИУпаковки Тогда
				ОбластьСтрокаТаблицыЯчейка.Параметры.Заполнить(ВыборкаПоСтрокамТЧ);
				ТабличныйДокумент.Присоединить(ОбластьСтрокаТаблицыЯчейка);
			КонецЕсли;
			
			Если ВыводитьКоды Тогда
				ОбластьСтрокаТаблицыКолонкаКодов.Параметры.Артикул = ВыборкаПоСтрокамТЧ.ДопКолонка;
				ТабличныйДокумент.Присоединить(ОбластьСтрокаТаблицыКолонкаКодов);
			КонецЕсли;
			
			ОбластьСтрокаТаблицыКолонкаТоваров.Параметры.Товар = НоменклатураКлиентСервер.ПредставлениеНоменклатурыДляПечати(
				ВыборкаПоСтрокамТЧ.ПредставлениеНоменклатуры,
				ВыборкаПоСтрокамТЧ.ПредставлениеХарактеристики,
				, // Упаковка
				ВыборкаПоСтрокамТЧ.ПредставлениеСерии);
			
			ТабличныйДокумент.Присоединить(ОбластьСтрокаТаблицыКолонкаТоваров);
			
			Если ВыводитьЯчейкиИУпаковки Тогда
				ОбластьСтрокаТаблицыКолонкаУпаковок.Параметры.Заполнить(ВыборкаПоСтрокамТЧ);
				ТабличныйДокумент.Присоединить(ОбластьСтрокаТаблицыКолонкаУпаковок);
			КонецЕсли;
			
			ОбластьСтрокаТаблицыКонец.Параметры.Заполнить(ВыборкаПоСтрокамТЧ);
			ТабличныйДокумент.Присоединить(ОбластьСтрокаТаблицыКонец);	
				
		КонецЦикла;
		
		ТабличныйДокумент.Вывести(ОбластьПодвалТаблицыНачало);
		
		Если ВыводитьЯчейкиИУпаковки Тогда
			ОбластьПодвалТаблицыЯчейка.Параметры.Заполнить(ВыборкаПоСтрокамТЧ);
			ТабличныйДокумент.Присоединить(ОбластьПодвалТаблицыЯчейка);
		КонецЕсли;
		
		Если ВыводитьКоды Тогда
			ТабличныйДокумент.Присоединить(ОбластьПодвалТаблицыКолонкаКодов);
		КонецЕсли;
		ТабличныйДокумент.Присоединить(ОбластьПодвалТаблицыКолонкаТоваров);
		Если ВыводитьЯчейкиИУпаковки Тогда
			ТабличныйДокумент.Присоединить(ОбластьПодвалТаблицыКолонкаУпаковок);
		КонецЕсли;
		ТабличныйДокумент.Присоединить(ОбластьПодвалТаблицыКонец);
		
		// Вывод подписей.
		ОбластьПодписей.Параметры.Ответственный = ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(ВыборкаПоДокументам.Ответственный, ВыборкаПоДокументам.Дата);
		ОбластьПодписей.Параметры.Кладовщик = ФизическиеЛицаУТ.ФамилияИнициалыФизЛица(ВыборкаПоДокументам.Кладовщик, ВыборкаПоДокументам.Дата);		
		ОбластьПодписей.Параметры.КладовщикДолжность = СкладыСервер.ДолжностьОтветственногоЛицаСклада(ВыборкаПоДокументам.КладовщикДолжность);
		ТабличныйДокумент.Вывести(ОбластьПодписей);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ВыборкаПоДокументам.Ссылка);
		
	КонецЦикла;
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Если ПривилегированныйРежим() Тогда
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	Возврат ТабличныйДокумент;	
КонецФункции

Функция ТекстЗапросаВтТаблицаТовары(Запрос, ТекстыЗапроса)
	
	ИмяРегистра = "ВтТаблицаТовары";
		
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Товары.Номенклатура,
	|	Товары.Характеристика,
	|	Товары.Назначение,
	|	Товары.Серия,
	|	Товары.СтатусУказанияСерий КАК СтатусУказанияСерий,
	|	Товары.Количество
	|ПОМЕСТИТЬ ВтТаблицаТовары
	|ИЗ
	|	Документ.ОрдерНаОтражениеНедостачТоваров.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка = &Ссылка
	|	И ЕСТЬNULL(Товары.Упаковка.ТипУпаковки, НЕОПРЕДЕЛЕНО) <> ЗНАЧЕНИЕ(Перечисление.ТипыУпаковокНоменклатуры.ТоварноеМесто)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Таблица.Номенклатура,
	|	Таблица.Характеристика,
	|	Таблица.Назначение,
	|	Таблица.Серия,
	|	Таблица.СтатусУказанияСерий,
	|	СУММА(ТоварыКоличество.Количество)
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТоварыУпаковка.Ссылка КАК Ссылка,
	|		ТоварыУпаковка.Номенклатура КАК Номенклатура,
	|		ТоварыУпаковка.Характеристика КАК Характеристика,
	|		ТоварыУпаковка.Назначение КАК Назначение,
	|		ТоварыУпаковка.Серия КАК Серия,
	|		МАКСИМУМ(ТоварыУпаковка.Упаковка) КАК Упаковка,
	|		ТоварыУпаковка.СтатусУказанияСерий КАК СтатусУказанияСерий
	|	ИЗ
	|		Документ.ОрдерНаОтражениеНедостачТоваров.Товары КАК ТоварыУпаковка
	|	ГДЕ
	|		ТоварыУпаковка.Ссылка = &Ссылка
	|		И ЕСТЬNULL(ТоварыУпаковка.Упаковка.ТипУпаковки, НЕОПРЕДЕЛЕНО) = ЗНАЧЕНИЕ(Перечисление.ТипыУпаковокНоменклатуры.ТоварноеМесто)
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ТоварыУпаковка.Ссылка,
	|		ТоварыУпаковка.Номенклатура,
	|		ТоварыУпаковка.Характеристика,
	|		ТоварыУпаковка.Назначение,
	|		ТоварыУпаковка.Серия,
	|		ТоварыУпаковка.СтатусУказанияСерий) КАК Таблица
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ОрдерНаОтражениеНедостачТоваров.Товары КАК ТоварыКоличество
	|		ПО Таблица.Ссылка = ТоварыКоличество.Ссылка
	|			И Таблица.Номенклатура = ТоварыКоличество.Номенклатура
	|			И Таблица.Характеристика = ТоварыКоличество.Характеристика
	|			И Таблица.Серия = ТоварыКоличество.Серия
	|			И Таблица.Назначение = ТоварыКоличество.Назначение
	|			И Таблица.Упаковка = ТоварыКоличество.Упаковка
	|
	|СГРУППИРОВАТЬ ПО
	|	Таблица.Номенклатура,
	|	Таблица.Характеристика,
	|	Таблица.Назначение,
	|	Таблица.Серия,
	|	Таблица.СтатусУказанияСерий";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

#КонецОбласти

#КонецОбласти

#КонецЕсли
