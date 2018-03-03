﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

//Имена реквизитов, от значений которых зависят параметры указания серий
//
//	Возвращаемое значение:
//		Строка - имена реквизитов, перечисленные через запятую
//
Функция ИменаРеквизитовДляЗаполненияПараметровУказанияСерий() Экспорт
	ИменаРеквизитов = "Склад,Помещение,Статус,СкладскаяОперация,Дата";
	
	Возврат ИменаРеквизитов;
КонецФункции

// Возвращает параметры указания серий для товаров, указанных в документе.
//
// Параметры:
//		Объект - Структура - структура значений реквизитов объекта, необходимых для заполнения параметров указания серий.
//
// Возвращаемое значение:
//		Структура - состав полей структуры задается в функции НоменклатураКлиентСервер.ПараметрыУказанияСерий.
//
Функция ПараметрыУказанияСерий(Объект) Экспорт
	
	ПараметрыУказанияСерий = Документы.ПриходныйОрдерНаТовары.ПараметрыУказанияСерий(Объект);
	
	ПараметрыУказанияСерий.ПолноеИмяОбъекта = "Обработка.ПроверкаКоличестваТоваровВПриходномОрдере";
	ПараметрыУказанияСерий.ИмяТЧСерии = "Товары";
	
	Возврат ПараметрыУказанияСерий;
	
КонецФункции

// Возвращает значение распоряжения на поступление или отгрузку
//
// Параметры:
//  ЗначенияПолейДляОпределенияРаспоряжения	 - Структура - состав полей определяется значением
//  поля ИменаПолейДляОпределенияРаспоряжения параметров указания серий этого документа
// 
// Возвращаемое значение:
//  ДокументСсылка - распоряжение
//
Функция РаспоряжениеНаВыполнениеСкладскойОперации(ЗначенияПолейДляОпределенияРаспоряжения) Экспорт
	Возврат ЗначенияПолейДляОпределенияРаспоряжения.Распоряжение;	
КонецФункции

// Возвращает складскую операцию по типу распоряжения.
//  Если распоряжение не указано, то по умолчанию считается, что операция - "Приемка от поставщика".
//
// Параметры:
//  Распоряжение - ДокументСсылка	 - ссылка на документ-распоряжение на поступление товаров.
// 
// Возвращаемое значение:
//  ПеречислениеСсылка.СкладскиеОперации - складская операция распоряжения.
//
Функция СкладскаяОперацияПоРаспоряжению(Распоряжение) Экспорт
	
	ТипРаспоряжения = ТипЗнч(Распоряжение);
	
	Если Не ЗначениеЗаполнено(Распоряжение) Тогда
		
		Возврат Перечисления.СкладскиеОперации.ВозвратНепринятыхТоваров;
		
	ИначеЕсли ТипРаспоряжения = Тип("ДокументСсылка.ЗаказПоставщику")
		Или ТипРаспоряжения = Тип("ДокументСсылка.ПоступлениеТоваровУслуг")
		Или ТипРаспоряжения = Тип("СправочникСсылка.СоглашенияСПоставщиками") Тогда 
		
		Возврат Перечисления.СкладскиеОперации.ПриемкаОтПоставщика;
		
	ИначеЕсли ТипРаспоряжения = Тип("ДокументСсылка.ЗаказНаСборку")
		Или ТипРаспоряжения = Тип("ДокументСсылка.СборкаТоваров") Тогда
		
		ХозяйственнаяОперация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Распоряжение, "ХозяйственнаяОперация");
		
		Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СборкаТоваров Тогда
			Возврат Перечисления.СкладскиеОперации.ПриемкаСобранныхКомплектов;
		Иначе
			Возврат Перечисления.СкладскиеОперации.ПриемкаКомплектующихПослеРазборки;
		КонецЕсли;
		
	ИначеЕсли ТипРаспоряжения = Тип("ДокументСсылка.ЗаказНаПеремещение")
		Или ТипРаспоряжения = Тип("ДокументСсылка.ПеремещениеТоваров") Тогда
		
		Возврат Перечисления.СкладскиеОперации.ПриемкаПоПеремещению;
		
	ИначеЕсли ТипРаспоряжения = Тип("ДокументСсылка.ЗаявкаНаВозвратТоваровОтКлиента")
		Или ТипРаспоряжения = Тип("ДокументСсылка.ВозвратТоваровОтКлиента") Тогда
		
		Возврат Перечисления.СкладскиеОперации.ПриемкаПоВозвратуОтКлиента;
		
	ИначеЕсли ТипРаспоряжения = Тип("ДокументСсылка.ПрочееОприходованиеТоваров")
		//++ НЕ УТ
		Или ТипРаспоряжения = Тип("ДокументСсылка.ВозвратМатериаловИзПроизводства")
		//-- НЕ УТ
		Тогда
		
		Возврат Перечисления.СкладскиеОперации.ПриемкаПоПрочемуОприходованию;
		
	//++ НЕ УТ
	ИначеЕсли ТипРаспоряжения = Тип("ДокументСсылка.ВыпускПродукции") 
		//++ НЕ УТКА
		Или ТипРаспоряжения = Тип("ДокументСсылка.ДвижениеПродукцииИМатериалов")
		Или ТипРаспоряжения = Тип("ДокументСсылка.ЗаказНаПроизводство")
		//-- НЕ УТКА
		Тогда
		
		Возврат Перечисления.СкладскиеОперации.ПриемкаПродукцииИзПроизводства;
	//-- НЕ УТ
	Иначе
		
		Возврат Перечисления.СкладскиеОперации.ПриемкаОтПоставщика;
		
	КонецЕсли;
	
КонецФункции

// Возвращает текст запроса для расчета статусов указания серий
//	Параметры:
//		ПараметрыУказанияСерий - Структура - состав полей задается в функции НоменклатураКлиентСервер.ПараметрыУказанияСерий
//	Возвращаемое значение:
//		Строка - текст запроса
//
Функция ТекстЗапросаЗаполненияСтатусовУказанияСерий(ПараметрыУказанияСерий) Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Товары.Номенклатура,
	|	Товары.Серия,
	|	Товары.СтатусУказанияСерий,
	|	Товары.НомерСтроки
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	&Товары КАК Товары
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
	|				КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПланированииОтгрузки
	|					ТОГДА ВЫБОР
	|							КОГДА Товары.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|								ТОГДА ВЫБОР
	|										КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УчитыватьСебестоимостьПоСериям
	|											ТОГДА 14
	|										ИНАЧЕ 10
	|									КОНЕЦ
	|							КОГДА Товары.Серия = ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|									И &ПодготовкаОрдера
	|								ТОГДА 11
	|							ИНАЧЕ ВЫБОР
	|									КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УчитыватьСебестоимостьПоСериям
	|										ТОГДА 13
	|									ИНАЧЕ 9
	|								КОНЕЦ
	|						КОНЕЦ
	|				КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПланированииОтбора
	|					ТОГДА ВЫБОР
	|							КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УчетСерийПоFEFO
	|								ТОГДА ВЫБОР
	|										КОГДА Товары.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|											ТОГДА 6
	|										КОГДА Товары.Серия = ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|												И &ПодготовкаОрдера
	|											ТОГДА 11
	|										ИНАЧЕ 5
	|									КОНЕЦ
	|							ИНАЧЕ ВЫБОР
	|									КОГДА Товары.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|										ТОГДА 8
	|									КОГДА Товары.Серия = ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|											И &ПодготовкаОрдера
	|										ТОГДА 11
	|									ИНАЧЕ 7
	|								КОНЕЦ
	|						КОНЕЦ
	|				КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПриемке
	|					ТОГДА ВЫБОР
	|							КОГДА ПолитикиУчетаСерий.ПолитикаУчетаСерий.УчитыватьОстаткиСерий
	|								ТОГДА ВЫБОР
	|										КОГДА Товары.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|											ТОГДА 4
	|										КОГДА Товары.Серия = ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|												И &ПодготовкаОрдера
	|											ТОГДА 11
	|										ИНАЧЕ 3
	|									КОНЕЦ
	|							ИНАЧЕ ВЫБОР
	|									КОГДА Товары.Серия <> ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|										ТОГДА 2
	|									КОГДА Товары.Серия = ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)
	|											И &ПодготовкаОрдера
	|										ТОГДА 11
	|									ИНАЧЕ 1
	|								КОНЕЦ
	|						КОНЕЦ
	|				ИНАЧЕ 0
	|			КОНЕЦ
	|	КОНЕЦ КАК СтатусУказанияСерий
	|ПОМЕСТИТЬ ТаблицаСтатусов
	|ИЗ
	|	Товары КАК Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыНоменклатуры.ПолитикиУчетаСерий КАК ПолитикиУчетаСерий
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Склады КАК Склады
	|			ПО ПолитикиУчетаСерий.Склад = Склады.Ссылка
	|		ПО (ВЫРАЗИТЬ(Товары.Номенклатура КАК Справочник.Номенклатура).ВидНоменклатуры = ПолитикиУчетаСерий.Ссылка)
	|			И (ПолитикиУчетаСерий.Склад = &Склад)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаСтатусов.НомерСтроки КАК НомерСтроки,
	|	ТаблицаСтатусов.СтатусУказанияСерий КАК СтатусУказанияСерий
	|ИЗ
	|	ТаблицаСтатусов КАК ТаблицаСтатусов
	|ГДЕ
	|	ТаблицаСтатусов.СтарыйСтатусУказанияСерий <> ТаблицаСтатусов.СтатусУказанияСерий
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	ЭтоВозвратНепринятыхТоваров = ПараметрыУказанияСерий.СкладскиеОперации
		.Найти(Перечисления.СкладскиеОперации.ВозвратНепринятыхТоваров) <> Неопределено;
	ЭтоВозвратНепринятыхТоваровУстаревший = ПараметрыУказанияСерий.СкладскиеОперации
		.Найти(Перечисления.СкладскиеОперации.ВозвратНепринятыхТоваровУстарел) <> Неопределено;
	
	Если ЭтоВозвратНепринятыхТоваров
		Или ЭтоВозвратНепринятыхТоваровУстаревший Тогда
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПриемке",
			"ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриОтгрузке");
			
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПриемке",
			"ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПриемке
			|						И (ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПриемкеОтПоставщика
			|								И &ПриемкаОтПоставщика
			|							ИЛИ ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПриемкеПоВозвратуОтКлиента
			|								И &ПриемкаПоВозвратуОтКлиента
			//++ НЕ УТ
			|							ИЛИ ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПриемкеПродукцииИзПроизводства
			|								И &ПриемкаПродукцииИзПроизводства
			//-- НЕ УТ
			|							ИЛИ ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПриемкеПоПеремещению
			|								И &ПриемкаПоПеремещению
			|							ИЛИ ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПриемкеПоПрочемуОприходованию
			|								И &ПриемкаПоПрочемуОприходованию
			|							ИЛИ ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПриемкеКомплектующихПослеРазборки
			|								И &ПриемкаКомплектующихПослеРазборки
			|							ИЛИ ПолитикиУчетаСерий.ПолитикаУчетаСерий.УказыватьПриПриемкеСобранныхКомплектов
			|								И &ПриемкаСобранныхКомплектов)");
	КонецЕсли;

	Возврат ТекстЗапроса;
	
КонецФункции

// Возвращает текст запроса для получениях доступных назначений
//	Параметры:
//		ПараметрыФормированияЗапроса - Структура - параметры для формирования текстов запросов
//	Возвращаемое значение:
//		Строка - текст запроса
//
Функция ТекстЗапросаДоступныхНазначений(ПараметрыФормированияЗапроса) Экспорт
	
	Возврат Документы.ПриходныйОрдерНаТовары.ТекстЗапросаДоступныхНазначений(ПараметрыФормированияЗапроса);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти

#КонецЕсли
