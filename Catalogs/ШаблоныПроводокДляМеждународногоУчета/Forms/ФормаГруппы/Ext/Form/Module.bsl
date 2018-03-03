﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Объект.ЭтоГруппаШаблонов = Истина;
	
	Если Не ЗначениеЗаполнено(Параметры.Ключ) Тогда
		Заголовок = НСтр("ru = 'Шаблоны проводок (Создание группы)'");
		АвтоЗаголовок = Ложь;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Параметры.Ключ) Или ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		Справочники.ШаблоныПроводокДляМеждународногоУчета.ИнициализироватьКомпоновщик(ЭтотОбъект, Объект.Операция);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		СохраненныеНастройки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.ЗначениеКопирования, "ДополнительныйОтбор").Получить();
		Справочники.ШаблоныПроводокДляМеждународногоУчета.ЗагрузитьНастройки(ЭтотОбъект, СохраненныеНастройки);
	КонецЕсли;

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	Справочники.ШаблоныПроводокДляМеждународногоУчета.ЗаписатьДополнительныйОтбор(ЭтотОбъект, ТекущийОбъект);
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	Справочники.ШаблоныПроводокДляМеждународногоУчета.ИнициализироватьКомпоновщик(ЭтотОбъект, ТекущийОбъект.Операция);
	
	СохраненныеНастройки = ТекущийОбъект.ДополнительныйОтбор.Получить();
	Справочники.ШаблоныПроводокДляМеждународногоУчета.ЗагрузитьНастройки(ЭтотОбъект, СохраненныеНастройки);
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Заголовок = "";
	АвтоЗаголовок = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы


#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции


#КонецОбласти
