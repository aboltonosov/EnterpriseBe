﻿&НаКлиенте
Перем ВыполняетсяЗакрытие;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ТоварыНакладной = ПолучитьИзВременногоХранилища(Параметры.АдресТовары);
	ЗаполнитьРеквизитыПриСоздании(ТоварыНакладной);
	ЗаполнитьТаблицуТоваров(ТоварыНакладной);
	
	УстановитьОтборСтрок();
	
	НастроитьЭлементыФормыПриСоздании();
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)

	Если Не ВыполняетсяЗакрытие И Модифицированность Тогда
		Отказ = Истина;
		ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект),
		НСтр("ru = 'Данные были изменены. Перенести изменения в документ?'"), РежимДиалогаВопрос.ДаНетОтмена);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт

	Ответ = РезультатВопроса;
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		ВыполняетсяЗакрытие = Истина;
		ПеренестиСтрокиВДокумент();
		
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		
		Модифицированность = Ложь;
		ВыполняетсяЗакрытие = Истина;
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ПоОрдеруПриИзменении(Элемент)
	
	РассчитатьПоказательСтрокиКоличество();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоЗаказуПриИзменении(Элемент)
	
	ПоЗаказамПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьЗаголовокЗаказыПриИзменении(Элемент)
	
	СтандартнаяОбработка = Ложь;
	ЗаголовокСпискаЗаказов = НСтр("ru='Заказы (%КоличествоДокументов%)'");
	ПараметрыФормы = Новый Структура("СписокДокументов, Заголовок", СписокРаспоряжений, ЗаголовокСпискаЗаказов);
	
	ОткрытьФорму("ОбщаяФорма.ПросмотрСпискаДокументов", ПараметрыФормы, ЭтаФорма, УникальныйИдентификатор,
		,, Неопределено, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицыФормыТовары

&НаКлиенте
Процедура ТаблицаТоварыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элементы.ТаблицаТовары.ТекущиеДанные <> Неопределено Тогда
		
		Если Поле.Имя = "ТаблицаТоварыЗаказ"
			И ЗначениеЗаполнено(Элементы.ТаблицаТовары.ТекущиеДанные.Заказ) Тогда
			ПоказатьЗначение(Неопределено, Элементы.ТаблицаТовары.ТекущиеДанные.Заказ);
		ИначеЕсли Поле.Имя = "ТаблицаТоварыСделка"
			И ЗначениеЗаполнено(Элементы.ТаблицаТовары.ТекущиеДанные.Сделка) Тогда
			ПоказатьЗначение(Неопределено, Элементы.ТаблицаТовары.ТекущиеДанные.Сделка);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)

	ПеренестиСтрокиВДокумент();

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСтроки(Команда)

	ОтметитьСтроки(Истина);

КонецПроцедуры

&НаКлиенте
Процедура ИсключитьСтроки(Команда)

	ОтметитьСтроки(Ложь);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//
	
	НоменклатураСервер.УстановитьУсловноеОформлениеЕдиницИзмерения(ЭтаФорма, "ТаблицаТоварыЕдиницаИзмерения", "ТаблицаТовары.Упаковка");

	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаТовары.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаТовары.ПрисутствуетВДокументе");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Gray);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаТоварыЗаказ.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаТовары.Заказ");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветГиперссылки);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаТоварыКоличествоУпаковокВЗаказе.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПоОрдеру");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.ЦветФонаПолностьюОбеспечен);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаТоварыКоличествоУпаковокВОрдере.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПоОрдеру");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.ЦветФонаПолностьюОбеспечен);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаТоварыКоличествоУпаковок.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаТовары.КоличествоУпаковок");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 0;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаТовары.СтрокаВыбрана");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<удалить>'"));

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуТоваров(ТоварыНакладной)
	
	ТоварыНакладной.Колонки.Добавить("КоличествоВНакладной", Новый ОписаниеТипов("Число"));
	ТоварыНакладной.Колонки.Добавить("КоличествоУпаковокВНакладной", Новый ОписаниеТипов("Число"));
	
	Для Каждого Строка Из ТоварыНакладной Цикл
		Строка.КоличествоВНакладной = Строка.Количество;
		Строка.КоличествоУпаковокВНакладной = Строка.КоличествоУпаковок;
	КонецЦикла;
	
	СписокРаспоряжений.Добавить(Накладная);
	
	Если ТипЗнч(Накладная) = Тип("ДокументСсылка.ВнутреннееПотреблениеТоваров") Тогда
		ДозаполнитьТоварыВнутреннееПотреблениеТоваров(ТоварыНакладной);
	ИначеЕсли ТипЗнч(Накладная) = Тип("ДокументСсылка.СборкаТоваров") Тогда
		ДозаполнитьТоварыСборкаТоваров(ТоварыНакладной);
	ИначеЕсли ТипЗнч(Накладная) = Тип("ДокументСсылка.ПеремещениеТоваров") Тогда
		ДозаполнитьТоварыПеремещениеТоваров(ТоварыНакладной);
	//++ НЕ УТКА
	ИначеЕсли ТипЗнч(Накладная) = Тип("ДокументСсылка.ДвижениеПродукцииИМатериалов") Тогда
		ДозаполнитьДвижениеПродукцииИМатериалов(ТоварыНакладной);
	//-- НЕ УТКА
	КонецЕсли;
	
	ТаблицаТовары.Загрузить(ТоварыНакладной);
	
	УдалитьСтрокиБезОтклонений();
	
	ПересчитатьКоличествоУпаковок();
	
	РассчитатьПоказательСтрокиКоличество();
	
КонецПроцедуры

&НаСервере
Функция ПересчитатьКоличествоУпаковок()
	
	Для Каждого Строка Из ТаблицаТовары Цикл
		
		СтруктураДействий = Новый Структура();
		СтруктураДействий.Вставить("ПересчитатьКоличествоУпаковокСуффикс", "ВЗаказе");
		ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(Строка, СтруктураДействий, Неопределено);
		
		СтруктураДействий = Новый Структура();
		СтруктураДействий.Вставить("ПересчитатьКоличествоУпаковокСуффикс", "Собирается");
		ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(Строка, СтруктураДействий, Неопределено);
		
		СтруктураДействий = Новый Структура();
		СтруктураДействий.Вставить("ПересчитатьКоличествоУпаковокСуффикс", "ВОрдере");
		ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(Строка, СтруктураДействий, Неопределено);
		
	КонецЦикла;
	
КонецФункции

&НаСервере
Процедура РассчитатьПоказательСтрокиКоличество()
	
	Для Каждого ТекущаяСтрока Из ТаблицаТовары Цикл
		ТекущаяСтрока.КоличествоУпаковок = ?(ПоОрдеру, ТекущаяСтрока.КоличествоУпаковокВОрдере, ТекущаяСтрока.КоличествоУпаковокВЗаказе);
		ТекущаяСтрока.Количество = ?(ПоОрдеру, ТекущаяСтрока.КоличествоВОрдере, ТекущаяСтрока.КоличествоВЗаказе);
		
		ТекущаяСтрока.СтрокаВыбрана = (ТекущаяСтрока.КоличествоУпаковок <> ТекущаяСтрока.КоличествоУпаковокВНакладной)
			И (ТекущаяСтрока.ЗаказИзНакладной И ПоЗаказам Или Не ПоЗаказам);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьСтрокиБезОтклонений()
	
	КоличествоСтрок = ТаблицаТовары.Количество();
	Для Счетчик = 1 По КоличествоСтрок Цикл
		
		СтрокаТаблицы = ТаблицаТовары[КоличествоСтрок - Счетчик];
		
		РаспоряжениеНакладная = ТипЗнч(СтрокаТаблицы.Заказ) = Тип("ДокументСсылка.ВнутреннееПотреблениеТоваров")
			//++ НЕ УТ
			Или ТипЗнч(СтрокаТаблицы.Заказ) = Тип("ДокументСсылка.ПередачаМатериаловВПроизводство")
			//-- НЕ УТ
			Или ТипЗнч(СтрокаТаблицы.Заказ) = Тип("ДокументСсылка.ПеремещениеТоваров");
		
		НетОтклоненийЗаказ = СтрокаТаблицы.КодСтроки = 0 Или СтрокаТаблицы.КоличествоВНакладной = СтрокаТаблицы.КоличествоВЗаказе;
		НетОтклоненийОрдер = Не ИспользоватьОрдернуюСхемуПриОтгрузке Или СтрокаТаблицы.КоличествоВНакладной = СтрокаТаблицы.КоличествоВОрдере;
		НетОтклонений = НетОтклоненийЗаказ И НетОтклоненийОрдер;
		
		Если НетОтклонений Тогда
			ТаблицаТовары.Удалить(КоличествоСтрок - Счетчик);
			Продолжить;
		КонецЕсли;
		
		Если РаспоряжениеНакладная Тогда
			СтрокаТаблицы.Заказ = Неопределено;
		КонецЕсли;
		
		Если СписокРаспоряжений.НайтиПоЗначению(СтрокаТаблицы.Заказ) <> Неопределено
			Или СтрокаТаблицы.Заказ = Заказ Тогда
			
			СтрокаТаблицы.ЗаказИзНакладной = Истина;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДозаполнитьТоварыВнутреннееПотреблениеТоваров(ТаблицаНакладная)
	
	ПараметрыЗаполнения = Документы.ВнутреннееПотреблениеТоваров.ПараметрыЗаполненияДокумента();
	ПараметрыЗаполнения.Вставить("ЗаполнятьПоОрдеру", Истина);
	
	МассивЗаказов = Новый Массив();
	МассивЗаказов.Добавить(Заказ);
	МассивЗаказов.Добавить(Накладная);
	
	Если ИспользоватьНакладныеПоНесколькимЗаказам Тогда
		// Получаем полный список подходящих заказов
		МассивЗаказов = Документы.ВнутреннееПотреблениеТоваров.РаспоряженияНакладной(Накладная, Новый Массив(), Параметры.РеквизитыШапки);
	КонецЕсли;
	
	ИспользоватьОтборПоСкладу = Ложь;
	
	//++ НЕ УТКА
	ЗаказМассива = МассивЗаказов[0];
	ИспользоватьОтборПоСкладу = (ТипЗнч(ЗаказМассива) = Тип("ДокументСсылка.ЗаказНаРемонт"));
	
	Если ЗначениеЗаполнено(Склад)
		И ТипЗнч(ЗаказМассива) = Тип("ДокументСсылка.ЗаказНаРемонт")
		И ПравоДоступа("Чтение", Метаданные.Документы.ЗаказНаРемонт)Тогда
		
		// Для заказа на ремонт необходимо выбрать один склад из множества возможных
		
		Запрос = Новый Запрос();
		Запрос.УстановитьПараметр("МассивЗаказов", МассивЗаказов);
		Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ЗаказНаРемонтМатериалыИРаботы.Склад КАК Склад
		|ИЗ
		|	Документ.ЗаказНаРемонт.МатериалыИРаботы КАК ЗаказНаРемонтМатериалыИРаботы
		|ГДЕ
		|	ЗаказНаРемонтМатериалыИРаботы.Ссылка В (&МассивЗаказов)";
		
		СкладЗаказаНаРемонт = Неопределено;
		Результат = Запрос.Выполнить().Выбрать();
		Если Результат.Следующий() Тогда
			СкладЗаказаНаРемонт = Результат.Склад;
		КонецЕсли;
		
		ПараметрыЗаполнения.Вставить("Склад", Склад);
		
	КонецЕсли;
	//-- НЕ УТКА
	
	ДопОтборы = Новый Структура();
	ДопОтборы.Вставить("Склад", ПараметрыЗаполнения.Склад);
	
	// Установка отметки на все строки до изменения таблицы
	ТаблицаНакладная.Колонки.Добавить("ПрисутствуетВДокументе", Новый ОписаниеТипов("Булево"));
	ТаблицаНакладная.ЗаполнитьЗначения(Истина, "ПрисутствуетВДокументе");
	
	Документы.ВнутреннееПотреблениеТоваров.ЗаполнитьПоЗаказамОрдерам(ТаблицаНакладная, Накладная, МассивЗаказов, ПараметрыЗаполнения, ДопОтборы);
	
	ТаблицаНакладная.Колонки.ЗаказНаВнутреннееПотребление.Имя = "Заказ";
	
КонецПроцедуры

&НаСервере
Процедура ДозаполнитьТоварыСборкаТоваров(ТаблицаНакладная)
	
	ПараметрыЗаполнения = Документы.СборкаТоваров.ПараметрыЗаполненияДокумента();
	ПараметрыЗаполнения.Вставить("ЗаполнятьПоОрдеру", Истина);
	
	МассивЗаказов = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Заказ);
	
	Если ЗначениеЗаполнено(Накладная) Тогда
		МассивЗаказов.Добавить(Накладная);
	КонецЕсли;
	
	// Получаем полный список подходящих заказов
	
	// Установка отметки на все строки до изменения таблицы
	ТаблицаНакладная.Колонки.Добавить("ПрисутствуетВДокументе", Новый ОписаниеТипов("Булево"));
	ТаблицаНакладная.ЗаполнитьЗначения(Истина, "ПрисутствуетВДокументе");
	
	ТаблицаНакладная.Колонки.Добавить("Картинка", Новый ОписаниеТипов("Число"));
	
	ХозяйственнаяОперация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Накладная, "ХозяйственнаяОперация");
	
	ПараметрыЗаполнения.Вставить("ХозяйственнаяОперация", ХозяйственнаяОперация);
	
	// Сборка по шапке или разборка по товарам - приходные ордера, иначе - расходные
	ПоРасходнымОрдерам = (ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СборкаТоваров);
	ПараметрыЗаполнения.ПоШапке = Ложь;
	ПараметрыЗаполнения.ПоРасходнымОрдерам = ПоРасходнымОрдерам;
	
	Документы.СборкаТоваров.ЗаполнитьПоЗаказамОрдерам(ТаблицаНакладная, 
		Накладная, 
		МассивЗаказов, 
		ПараметрыЗаполнения);
	
	ПоРасходнымОрдерам = (ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РазборкаТоваров);
	ПараметрыЗаполнения.ПоШапке = Истина;
	ПараметрыЗаполнения.ПоРасходнымОрдерам = ПоРасходнымОрдерам;
	
	Документы.СборкаТоваров.ЗаполнитьПоЗаказамОрдерам(ТаблицаНакладная, 
		Накладная, 
		МассивЗаказов, 
		ПараметрыЗаполнения);
	
	ТаблицаНакладная.Колонки.ЗаказНаСборку.Имя = "Заказ";
	
	КлючКомплекта = Новый Структура("Номенклатура, Характеристика");
	ЗаполнитьЗначенияСвойств(КлючКомплекта, Параметры.РеквизитыШапки);

	// Если комплект есть, он всегда идет первой строкой.
	Если ТаблицаНакладная.Количество() > 0
			И ТаблицаНакладная[0].Номенклатура   = КлючКомплекта.Номенклатура
			И ТаблицаНакладная[0].Характеристика = КлючКомплекта.Характеристика Тогда
		ТаблицаНакладная[0].Картинка = 1;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДозаполнитьТоварыПеремещениеТоваров(ТаблицаНакладная)
	
	ПараметрыЗаполнения = Документы.ПеремещениеТоваров.ПараметрыЗаполненияДокумента();
	ПараметрыЗаполнения.Вставить("ЗаполнятьПоОрдеру", Истина);
	
	МассивЗаказов = Новый Массив();
	МассивЗаказов.Добавить(Заказ);
	МассивЗаказов.Добавить(Накладная);
	
	Если ИспользоватьНакладныеПоНесколькимЗаказам Тогда
		// Получаем полный список подходящих заказов
		МассивЗаказов = Документы.ПеремещениеТоваров.РаспоряженияНакладной(Накладная, Новый Массив(), Параметры.РеквизитыШапки);
	КонецЕсли;
	
	// Установка отметки на все строки до изменения таблицы
	ТаблицаНакладная.Колонки.Добавить("ПрисутствуетВДокументе", Новый ОписаниеТипов("Булево"));
	ТаблицаНакладная.ЗаполнитьЗначения(Истина, "ПрисутствуетВДокументе");
	
	Документы.ПеремещениеТоваров.ЗаполнитьПоЗаказамОрдерам(ТаблицаНакладная, Накладная, МассивЗаказов, ПараметрыЗаполнения);
	
	ТаблицаНакладная.Колонки.ЗаказНаПеремещение.Имя = "Заказ";
	
КонецПроцедуры

//++ НЕ УТКА

&НаСервере
Процедура ДозаполнитьДвижениеПродукцииИМатериалов(ТаблицаНакладная)
	
	ПараметрыЗаполнения = Документы.ДвижениеПродукцииИМатериалов.ПараметрыЗаполненияДокумента();
	ПараметрыЗаполнения.Вставить("ЗаполнятьПоОрдеру", Истина);
	
	МассивЗаказов = Новый Массив();
	
	Если ИспользоватьНакладныеПоНесколькимЗаказам Тогда
		// Получаем полный список подходящих заказов
		МассивЗаказов = Документы.ДвижениеПродукцииИМатериалов.РаспоряженияНакладной(Накладная, МассивЗаказов, Параметры.РеквизитыШапки);
		МассивЗаказов.Добавить(Заказ);
	Иначе
		МассивЗаказов.Добавить(Заказ);
	КонецЕсли;
	
	// Получаем полный список подходящих заказов
	
	// Установка отметки на все строки до изменения таблицы
	ТаблицаНакладная.Колонки.Добавить("ПрисутствуетВДокументе", Новый ОписаниеТипов("Булево"));
	ТаблицаНакладная.ЗаполнитьЗначения(Истина, "ПрисутствуетВДокументе");
	
	РеквизитыНакладной = Параметры.РеквизитыШапки;
	Если РеквизитыНакладной.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаМатериаловВПроизводство
		Или РеквизитыНакладной.ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаМатериаловВКладовую Тогда
		Склад = РеквизитыНакладной.Отправитель;
	Иначе
		Склад = РеквизитыНакладной.Получатель;
	КонецЕсли;
	
	ДопОтборы = Новый Структура();
	ДопОтборы.Вставить("Склад",                 Склад);
	ДопОтборы.Вставить("Получатель",            РеквизитыНакладной.Получатель);
	ДопОтборы.Вставить("ХозяйственнаяОперация", РеквизитыНакладной.ХозяйственнаяОперация);
	
	Документы.ДвижениеПродукцииИМатериалов.ЗаполнитьПоЗаказамОрдерам(ТаблицаНакладная, 
		Накладная, 
		МассивЗаказов, 
		ПараметрыЗаполнения,
		ДопОтборы);
	
	ТаблицаНакладная.Колонки.Распоряжение.Имя = "Заказ";
	
КонецПроцедуры

//-- НЕ УТКА

&НаСервере
Процедура НастроитьЭлементыФормыПриСоздании()
	
	ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипЗнч(Накладная));
	МенеджерНакладной = Документы[ОбъектМетаданных.Имя];
	
	// Элементы формы.
	Элементы.ПоОрдеру.Видимость =      ИспользоватьЗаказы И ИспользоватьОрдернуюСхемуПриОтгрузке;
	Элементы.СтраницыЗаказ.Видимость = ИспользоватьЗаказы И Параметры.НакладнаяПоЗаказам И Параметры.ИспользоватьНакладныеПоНесколькимЗаказам;
	
	// Элементы таблицы товаров.
	Если ТипЗнч(Накладная) = Тип("ДокументСсылка.ВнутреннееПотреблениеТоваров") Тогда
		
		Элементы.ТаблицаТоварыДатаОтгрузки.Видимость = Истина;
		
	ИначеЕсли ТипЗнч(Накладная) = Тип("ДокументСсылка.СборкаТоваров") Тогда
		
		Элементы.ТаблицаТоварыКартинка.Видимость     = Истина;
		Элементы.ТаблицаТоварыДатаОтгрузки.Видимость = Истина;
		Элементы.ТаблицаТоварыСделка.Видимость       = Истина;
		
		Элементы.ТаблицаТоварыДатаОтгрузки.Заголовок = НСтр("ru = 'Дата отгрузки/приемки'");
		
	ИначеЕсли ТипЗнч(Накладная) = Тип("ДокументСсылка.ПеремещениеТоваров") Тогда
		
		Элементы.ТаблицаТоварыДатаОтгрузки.Видимость = Истина;
		Элементы.ТаблицаТоварыСделка.Видимость       = Истина;
		
	//++ НЕ УТКА
	ИначеЕсли ТипЗнч(Накладная) = Тип("ДокументСсылка.ДвижениеПродукцииИМатериалов") Тогда
		
		Элементы.ТаблицаТоварыДатаОтгрузки.Видимость = Истина;
	//-- НЕ УТКА
	КонецЕсли;
	
	ПараметрыОбъекта = Новый Структура(МенеджерНакладной.ИменаРеквизитовДляЗаполненияПараметровУказанияСерий());
	ЗаполнитьЗначенияСвойств(ПараметрыОбъекта, Параметры.РеквизитыШапки);
	ПараметрыУказанияСерий = НоменклатураСервер.ПараметрыУказанияСерий(ПараметрыОбъекта, МенеджерНакладной);
	
	Если ПараметрыУказанияСерий.Свойство("ИспользоватьСерииНоменклатуры") Тогда
		Элементы.ТаблицаТоварыСерия.Видимость = ПараметрыУказанияСерий.ИспользоватьСерииНоменклатуры;
	ИначеЕсли ПараметрыУказанияСерий.Свойство("ТЧ") Тогда
		Элементы.ТаблицаТоварыСерия.Видимость = ПараметрыУказанияСерий.ТЧ.ИспользоватьСерииНоменклатуры
												Или ПараметрыУказанияСерий.Шапка.ИспользоватьСерииНоменклатуры;
	КонецЕсли;
	
	Элементы.ТаблицаТоварыКоличествоУпаковокВОрдере.Видимость    = ИспользоватьОрдернуюСхемуПриОтгрузке;
	Элементы.ТаблицаТоварыКоличествоУпаковокСобирается.Видимость = ИспользоватьОрдернуюСхемуПриОтгрузке;
	
	Элементы.ТаблицаТоварыКоличествоУпаковокВЗаказе.Видимость    = ИспользоватьЗаказы;
	Элементы.ТаблицаТоварыЗаказ.Видимость                        = ИспользоватьЗаказы;
	Элементы.ТаблицаТоварыКодСтроки.Видимость                    = ИспользоватьЗаказы;
	
	ЕстьСобирающиесяТовары = ТаблицаТовары.Итог("КоличествоСобирается") > 0;
	Элементы.ДекорацияИнфо.Видимость = ЕстьСобирающиесяТовары;
	Элементы.ДекорацияИнформацияЕстьСобирающиесяТовары.Видимость = ЕстьСобирающиесяТовары;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыПриСоздании(ТоварыНакладной)
	
	// Реквизиты.
	ИспользоватьНакладныеПоНесколькимЗаказам = Параметры.ИспользоватьНакладныеПоНесколькимЗаказам;
	ИспользоватьОрдернуюСхемуПриОтгрузке     = Параметры.ОрдернаяСхемаПриОтгрузке;
	ИспользоватьОрдернуюСхемуПриПоступлении  = Параметры.ОрдернаяСхемаПриПоступлении;
	ЭтоРаспоряжениеНакладная                 = НакладныеСервер.ЕстьРасходныйОрдерДляЗаказовНаОтгрузку(Параметры.Накладная);
	ИспользоватьЗаказы                       = Параметры.ИспользуютсяЗаказы И Не ЭтоРаспоряжениеНакладная;
	Склад                                    = Параметры.Склад;
	Накладная                                = Параметры.Накладная;
	
	ПоОрдеру = ИспользоватьОрдернуюСхемуПриОтгрузке
		 И (Константы.ПорядокОформленияНакладныхРасходныхОрдеров.Получить()
			= Перечисления.ПорядокОформленияНакладныхРасходныхОрдеров.СначалаОрдера);
	
	ПоЗаказам = Параметры.НакладнаяПоЗаказам;
	
	Заказ = Параметры.Заказ;
	
	ОбновитьИнформациюПоЗаказамВФорме(ТоварыНакладной);
	
	Если ИспользоватьЗаказы И (ИспользоватьОрдернуюСхемуПриОтгрузке Или ИспользоватьОрдернуюСхемуПриПоступлении) Тогда
		Заголовок = НСтр("ru = 'Подбор товаров по заказу/ордерам'");
	ИначеЕсли ИспользоватьЗаказы Тогда
		Заголовок = НСтр("ru = 'Подбор товаров по заказу'");
	Иначе
		Заголовок = НСтр("ru = 'Подбор товаров по ордерам'");
	КонецЕсли;
	
	ПодборТоваровКлиентСервер.СформироватьЗаголовокФормыПодбора(Заголовок, Параметры.РеквизитыШапки.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьИнформациюПоЗаказамВФорме(ТоварыНакладной) Экспорт
	
	Если Не ИспользоватьНакладныеПоНесколькимЗаказам Тогда
		Возврат;
	КонецЕсли;
	
	ИмяЗаказаВТабличнойЧасти = ИмяКолонкиЗаказ();
	
	СписокРаспоряжений.Очистить();
	Для Каждого ТекСтрока Из ТоварыНакладной Цикл
		Если ЗначениеЗаполнено(ТекСтрока[ИмяЗаказаВТабличнойЧасти]) И СписокРаспоряжений.НайтиПоЗначению(ТекСтрока[ИмяЗаказаВТабличнойЧасти]) = Неопределено Тогда
			СписокРаспоряжений.Добавить(ТекСтрока[ИмяЗаказаВТабличнойЧасти]);
		КонецЕсли;
	КонецЦикла;
	
	Если ИспользоватьНакладныеПоНесколькимЗаказам Тогда
		Если СписокРаспоряжений.Количество() = 1 Тогда
			Заказ = СписокРаспоряжений[0].Значение;
		ИначеЕсли СписокРаспоряжений.Количество() > 1 Тогда
			Заказ = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	Если СписокРаспоряжений.Количество() > 1 Тогда
		НадписьВсегоЗаказов = НСтр("ru = 'Всего заказов'");
		НадписьЗаголовокЗаказы = НадписьВсегоЗаказов + ": " + СписокРаспоряжений.Количество();
	КонецЕсли;
	
	Если СписокРаспоряжений.Количество() <= 1 Тогда
		Элементы.СтраницыЗаказ.ТекущаяСтраница = Элементы.СтраницаЗаказ;
	Иначе
		Элементы.СтраницыЗаказ.ТекущаяСтраница = Элементы.СтраницаЗаказы;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборСтрок()
	
	Если ПоЗаказам Тогда
		Элементы.ТаблицаТовары.ОтборСтрок = Новый ФиксированнаяСтруктура("ЗаказИзНакладной", Истина);
	Иначе
		Элементы.ТаблицаТовары.ОтборСтрок = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПоместитьТоварыВХранилище()
	
	ВозвращаемаяТаблица = ТаблицаТовары.Выгрузить();
	
	ВозвращаемаяТаблица.Колонки.Заказ.Имя = ИмяКолонкиЗаказ();
	
	АдресВХранилище = НакладныеСервер.ПодборПоЗаказамПоместитьТоварыВХранилище(ВозвращаемаяТаблица);
	Возврат АдресВХранилище;

КонецФункции

&НаСервере
Функция ИмяКолонкиЗаказ()
	
	Имя = "";
	
	Если ТипЗнч(Накладная) = Тип("ДокументСсылка.ВнутреннееПотреблениеТоваров") Тогда
		Имя = "ЗаказНаВнутреннееПотребление";
	ИначеЕсли ТипЗнч(Накладная) = Тип("ДокументСсылка.СборкаТоваров") Тогда
		Имя = "ЗаказНаСборку";
	ИначеЕсли ТипЗнч(Накладная) = Тип("ДокументСсылка.ПеремещениеТоваров") Тогда
		Имя = "ЗаказНаПеремещение";
	//++ НЕ УТКА
	ИначеЕсли ТипЗнч(Накладная) = Тип("ДокументСсылка.ДвижениеПродукцииИМатериалов") Тогда
		Имя = "Распоряжение";
	//-- НЕ УТКА
	КонецЕсли;
	
	Возврат Имя;
	
КонецФункции

&НаКлиенте
Процедура ПеренестиСтрокиВДокумент()
	
	// Снятие модифицированности, т.к. перед закрытием признак проверяется.
	Модифицированность = Ложь;
	
	ТекстПредупреждения = ПроверитьВыборНесколькихЗаказов();
	
	Если ТекстПредупреждения <> "" Тогда
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	АдресВХранилище = ПоместитьТоварыВХранилище();

	Закрыть();

	ОповеститьОВыборе(Новый Структура("ВыполняемаяОперация, АдресВХранилище",
						"ПодборТоваровИзЗаказа", АдресВХранилище));
	
КонецПроцедуры

&НаСервере
Функция ПроверитьВыборНесколькихЗаказов()
	
	Если ИспользоватьНакладныеПоНесколькимЗаказам Тогда
		
		ПервыйЗаказ = Неопределено;
		ВыбранаСтрокаБезЗаказа = Ложь;
		ШаблонБолееОдногоЗаказа = НСтр("ru = 'Нельзя выбрать товары больше, чем по одному заказу.'");
		ШаблонБезЗаказаИПоЗаказу = НСтр("ru = 'Нельзя выбрать товары по заказу и без указания заказа одновременно.'");
		
		Для Каждого СтрокаТовары Из ТаблицаТовары Цикл
			
			Если СтрокаТовары.СтрокаВыбрана И СтрокаТовары.Количество <> 0 Тогда
				
				Если ПервыйЗаказ <> Неопределено И СтрокаТовары.Заказ <> ПервыйЗаказ
					И Не ИспользоватьНакладныеПоНесколькимЗаказам Тогда
					Возврат ШаблонБолееОдногоЗаказа;
				ИначеЕсли ЗначениеЗаполнено(СтрокаТовары.Заказ) Тогда
					ПервыйЗаказ = СтрокаТовары.Заказ;
				КонецЕсли;
				
				Если Не ЗначениеЗаполнено(СтрокаТовары.Заказ) Тогда
					ВыбранаСтрокаБезЗаказа = Истина;
				КонецЕсли;
				
				Если ВыбранаСтрокаБезЗаказа И ПервыйЗаказ <> Неопределено Тогда
					Возврат ШаблонБезЗаказаИПоЗаказу;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат "";
	
КонецФункции

&НаСервере
Процедура ПоЗаказамПриИзмененииСервер()
	
	УстановитьОтборСтрок();
	
	Для каждого СтрокаТоваров Из ТаблицаТовары Цикл
		СтрокаТоваров.СтрокаВыбрана = (СтрокаТоваров.КоличествоУпаковок <> СтрокаТоваров.КоличествоУпаковокВНакладной)
			И (СтрокаТоваров.ЗаказИзНакладной И ПоЗаказам Или Не ПоЗаказам);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОтметитьСтроки(Значение)
	
	Для Каждого СтрокаТоваров Из ТаблицаТовары Цикл
			СтрокаТоваров.СтрокаВыбрана = Значение;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

ВыполняетсяЗакрытие = Ложь;