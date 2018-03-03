﻿&НаКлиенте
Перем ВыполняетсяЗакрытие;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("Организация",		Организация);
	Параметры.Свойство("АдресВХранилище",	АдресВХранилище);
	Параметры.Свойство("НаправлениеДеятельности", НаправлениеДеятельности);
	
	Параметры.Свойство("Подразделение",		Подразделение);
	Параметры.Свойство("Подразделение",		ПодразделениеПрежнее);
	
	Параметры.Свойство("Назначение",		Назначение);
	Параметры.Свойство("Назначение",		НазначениеПрежнее);
	
	Параметры.Свойство("НачалоПериода",		НачалоПериода);
	Параметры.Свойство("ОкончаниеПериода",	ОкончаниеПериода);
	
	Параметры.Свойство("ТолькоЭтапыСВыпуском", ТолькоЭтапыСВыпуском);
	
	Элементы.ЭтапыТекущегоМесяца.Видимость = Не ТолькоЭтапыСВыпуском;
	
	Элементы.ЭтапыТекущегоМесяца.Заголовок = 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Показывать только те партии, работы по которым выполнялись в текущем месяце (%1)'"), 
				Формат(НачалоПериода, "ДФ='MMMM yyyy'"));
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	Если Не ЗначениеЗаполнено(Настройки["ВариантПодбора"]) Тогда
		Настройки["ВариантПодбора"]			= "ПоПродукции";
		Настройки["ВариантПодбораПрежнее"]	= "ПоПродукции";
	КонецЕсли;
	
	Если Параметры.Свойство("Организация") Тогда
		Настройки["Организация"] = Параметры["Организация"];
	КонецЕсли;
	
	Если Параметры.Свойство("Подразделение") Тогда
		Настройки["Подразделение"] = Параметры["Подразделение"];
	КонецЕсли;
	
	Если Параметры.Свойство("Назначение") Тогда
		Настройки["Назначение"] = Параметры["Назначение"];
	КонецЕсли;
	
	Настройки["Организация"] = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Настройки["Организация"]);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ЗаполнитьТаблицуСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)

	Если Модифицированность Тогда
		Если НЕ ВыполняетсяЗакрытие Тогда
			Отказ = Истина;
			ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект), 
							НСтр("ru = 'Данные были изменены. Перенести изменения?'"),
							РежимДиалогаВопрос.ДаНетОтмена);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ВыполняетсяЗакрытие = Истина;
		ПеренестиСтрокиВДокумент();
		Закрыть();
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ВариантПодбораПриИзменении(Элемент)
	
	Если ВариантПодбора <> ВариантПодбораПрежнее Тогда
		ЗаполнитьТаблицуСервер();
		ВариантПодбораПрежнее = ВариантПодбора;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыТекущегоМесяцаПриИзменении(Элемент)
	
	ЗаполнитьТаблицуСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	Если Подразделение <> ПодразделениеПрежнее Тогда
		ЗаполнитьТаблицуСервер();
		ПодразделениеПрежнее = Подразделение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НазначениеПриИзменении(Элемент)
	
	Если Назначение <> НазначениеПрежнее Тогда
		ЗаполнитьТаблицуСервер();
		НазначениеПрежнее = Назначение;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВДокумент()

	ПеренестиСтрокиВДокумент();

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСтрокиЭтапы(Команда)
	
	ОтметитьСтроки(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьСтрокиЭтапы(Команда)
	
	ОтметитьСтроки(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокЭтапы(Команда)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьТаблицуСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Видимость партии производства
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПартииПроизводстваПартияПроизводства.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВариантПодбора");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = "ПоЭтапам";

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	// Видимость партии производства
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПартииПроизводстваЭтап.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВариантПодбора");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = "ПоПродукции";

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
КонецПроцедуры

#Область Прочее

&НаСервере
Функция ПоместитьСтрокиВХранилище()
	
	ТаблицаВыбранныхСтрок = ПартииПроизводства.Выгрузить(Новый Структура("СтрокаВыбрана", Истина));
	
	АдресВХранилище = ПоместитьВоВременноеХранилище(ТаблицаВыбранныхСтрок, АдресВХранилище);
	
	Возврат АдресВХранилище;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьТаблицуСервер()
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("НачалоПериода",			НачалоПериода);
	СтруктураПараметров.Вставить("ОкончаниеПериода",		ОкончаниеПериода);
	СтруктураПараметров.Вставить("Организация",				Организация);
	СтруктураПараметров.Вставить("Подразделение",			Подразделение);
	СтруктураПараметров.Вставить("Назначение",				Назначение);
	СтруктураПараметров.Вставить("НаправлениеДеятельности",	НаправлениеДеятельности);
	СтруктураПараметров.Вставить("ТолькоТекущийМесяц",		ЭтапыТекущегоМесяца);
	СтруктураПараметров.Вставить("ДетализироватьПоЭтапам",	?(ВариантПодбора = "ПоПродукции", Ложь, Истина));
	СтруктураПараметров.Вставить("ТолькоЭтапыСВыпуском",	ТолькоЭтапыСВыпуском);
	
	Результат = ЗатратыСервер.ПартииПроизводстваДляРаспределенияЗатрат(СтруктураПараметров);
	
	ПартииПроизводства.Загрузить(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиСтрокиВДокумент()
	
	АдресВХранилище = ПоместитьСтрокиВХранилище();
	Модифицированность = Ложь;
	
	Закрыть();
	
	ПараметрыВыбора = Новый Структура;
	ПараметрыВыбора.Вставить("АдресВХранилище", АдресВХранилище);
	
	ОповеститьОВыборе(ПараметрыВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьСтроки(Пометка)

	Если Элементы.ПартииПроизводства.ВыделенныеСтроки.Количество() > 1 Тогда
		Для каждого ИндексСтроки Из Элементы.ПартииПроизводства.ВыделенныеСтроки Цикл
			СтрокаПроизводство = Элементы.ПартииПроизводства.ДанныеСтроки(ИндексСтроки);
			СтрокаПроизводство.СтрокаВыбрана = Пометка;
		КонецЦикла;
	Иначе
		Для каждого СтрокаПроизводство Из ЭтаФорма.ПартииПроизводства Цикл
			СтрокаПроизводство.СтрокаВыбрана = Пометка;
		КонецЦикла; 
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецОбласти
