﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры, "АдресВХранилище, Документ, Заказ");
	
	ЗаполнитьТаблицуТоваров();
	
	ПодборТоваровКлиентСервер.СформироватьЗаголовокФормыПодбора(Заголовок, Параметры.Заказ);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	ОповещениеСохранитьИЗакрыть = Новый ОписаниеОповещения(
		"ПередЗакрытиемСохранитьИЗакрыть", ЭтотОбъект);
	
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(
		ОповещениеСохранитьИЗакрыть, Отказ, ЗавершениеРаботы);
		
КонецПроцедуры
	
&НаКлиенте
Процедура ПередЗакрытиемСохранитьИЗакрыть(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ПеренестиСтрокиВДокумент();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВДокумент()
	
	ПеренестиСтрокиВДокумент();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСтроки()
	
	ВыбратьВсеСтрокиНаСервере(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьСтроки()
	
	ВыбратьВсеСтрокиНаСервере(Ложь);
	
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

КонецПроцедуры

&НаСервере
Процедура ВыбратьВсеСтрокиНаСервере(ЗначениеВыбора = Истина)
	
	НайденныеСтроки = ТаблицаТоваров.НайтиСтроки(Новый Структура("СтрокаВыбрана", Не ЗначениеВыбора));
	
	Для Каждого СтрокаТаблицы Из НайденныеСтроки Цикл
		
		СтрокаТаблицы.СтрокаВыбрана = ЗначениеВыбора;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПоместитьСтрокиВХранилище()
	
	ТаблицаВыбранныхСтрок = ТаблицаТоваров.Выгрузить(Новый Структура("СтрокаВыбрана", Истина));
	
	АдресТоваровВХранилище = ПоместитьВоВременноеХранилище(ТаблицаВыбранныхСтрок);
	
	Возврат АдресТоваровВХранилище;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьТаблицуТоваров()
	
	ДанныеЗаказа = ПолучитьИзВременногоХранилища(АдресВХранилище);
	
	Выборка = Документы.ЗаказНаПроизводство.ПолучитьРезультатЗапросаПоОстаткамПродукцииКОбеспечениюДавальцу(Заказ, Документ).Выбрать();
	
	СтруктураОтбора = Новый Структура("Назначение, Номенклатура, Характеристика, Склад");
	
	Пока Выборка.Следующий() Цикл
		
		ЗаполнитьЗначенияСвойств(СтруктураОтбора, Выборка);
		НайденныеСтроки = ДанныеЗаказа.НайтиСтроки(СтруктураОтбора);
		
		КоличествоТребуется = Выборка.Количество;
		КоличествоУпаковокТребуется = Выборка.КоличествоУпаковок;
		
		Для Каждого Строка Из НайденныеСтроки Цикл
			КоличествоТребуется = КоличествоТребуется - Строка.Количество;
			КоличествоУпаковокТребуется = КоличествоУпаковокТребуется - Строка.КоличествоУпаковок;
		КонецЦикла;
		
		Если КоличествоТребуется > 0 Тогда
			
			НоваяСтрока = ТаблицаТоваров.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
			НоваяСтрока.Количество = КоличествоТребуется;
			НоваяСтрока.КоличествоУпаковок = КоличествоУпаковокТребуется;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиСтрокиВДокумент()
	
	АдресТоваровВХранилище = ПоместитьСтрокиВХранилище();
	
	Модифицированность = Ложь;
	Закрыть();
	
	ОповеститьОВыборе(АдресТоваровВХранилище);
	
КонецПроцедуры

#КонецОбласти

