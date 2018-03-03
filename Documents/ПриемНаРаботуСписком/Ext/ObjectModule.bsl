﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Подсистема "Управление доступом".

// Процедура ЗаполнитьНаборыЗначенийДоступа по свойствам объекта заполняет наборы значений доступа
// в таблице с полями:
//    НомерНабора     - Число                                     (необязательно, если набор один),
//    ВидДоступа      - ПланВидовХарактеристикСсылка.ВидыДоступа, (обязательно),
//    ЗначениеДоступа - Неопределено, СправочникСсылка или др.    (обязательно),
//    Чтение          - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Добавление      - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Изменение       - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//    Удаление        - Булево (необязательно, если набор для всех прав) устанавливается для одной строки набора,
//
//  Вызывается из процедуры УправлениеДоступомСлужебный.ЗаписатьНаборыЗначенийДоступа(),
// если объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьНаборыЗначенийДоступа" и
// из таких же процедур объектов, у которых наборы значений доступа зависят от наборов этого
// объекта (в этом случае объект зарегистрирован в "ПодпискаНаСобытие.ЗаписатьЗависимыеНаборыЗначенийДоступа").
//
// Параметры:
//  Таблица      - ТабличнаяЧасть,
//                 РегистрСведенийНаборЗаписей.НаборыЗначенийДоступа,
//                 ТаблицаЗначений, возвращаемая УправлениеДоступом.ТаблицаНаборыЗначенийДоступа().
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	ЗарплатаКадры.ЗаполнитьНаборыПоОрганизацииИФизическимЛицам(ЭтотОбъект, Таблица, "Организация", "Сотрудники.ФизическоеЛицо");
	
КонецПроцедуры

// Подсистема "Управление доступом".

#КонецОбласти


#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Действие") И ДанныеЗаполнения.Действие = "Исправить" Тогда
			
			ИсправлениеДокументовЗарплатаКадры.СкопироватьДокумент(ЭтотОбъект, ДанныеЗаполнения.Ссылка);
			
			ИсправленныйДокумент = ДанныеЗаполнения.Ссылка;
			ЗарплатаКадрыРасширенный.ПриКопированииМногофункциональногоДокумента(ЭтотОбъект);
			
		КонецЕсли;
	КонецЕсли;
	
	ЗарплатаКадрыРасширенный.ОбработкаЗаполненияМногофункциональногоДокумента(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("ГосударственнаяСлужба");
		Модуль.ОбработкаЗаполненияДокументаПриемНаРаботу(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Документы.ПриемНаРаботу.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Документы.ПриемНаРаботу.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	Документы.ПриемНаРаботу.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ДатаСобытия = Дата;
	
	ФОИспользоватьШтатноеРасписание = ПолучитьФункциональнуюОпцию("ИспользоватьШтатноеРасписание");
	Для каждого СтрокаСотрудника Из Сотрудники Цикл
		
		Если ФОИспользоватьШтатноеРасписание Тогда
			
			ДолжностьПозиции = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаСотрудника.ДолжностьПоШтатномуРасписанию, "Должность");
			Если СтрокаСотрудника.Должность <> ДолжностьПозиции Тогда
				СтрокаСотрудника.Должность = ДолжностьПозиции;
			КонецЕсли;
			
		Иначе
			
			Если ЗначениеЗаполнено(СтрокаСотрудника.ДолжностьПоШтатномуРасписанию) Тогда
				СтрокаСотрудника.ДолжностьПоШтатномуРасписанию = Справочники.ШтатноеРасписание.ПустаяСсылка();
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ЗарплатаКадрыРасширенный.ПередЗаписьюМногофункциональногоДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	НеРегистрироватьБухучет = ПолучитьФункциональнуюОпцию("ИспользоватьБронированиеПозиций") И БронированиеПозиции;
	ИмяТаблицы 			= "Документ.ПриемНаРаботуСписком.Сотрудники";
	ИмяПоляПериод 		= "Таблица.ДатаПриема";
	ИмяПоляДействуетДо 	= Неопределено;
	ОтражениеЗарплатыВБухучетеРасширенный.ОбновитьСведенияОБухучетеЗарплатыСотрудников(ЭтотОбъект,НеРегистрироватьБухучет,ИмяТаблицы,ИмяПоляПериод,ИмяПоляДействуетДо);	
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Если ОбъектКопирования.Проведен Тогда
		
		Сотрудники.Очистить();
		Начисления.Очистить();
		Показатели.Очистить();
		ЕжегодныеОтпуска.Очистить();
		Льготы.Очистить();
		
	КонецЕсли; 
	
	ЗарплатаКадрыРасширенный.ПриКопированииМногофункциональногоДокумента(ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#КонецЕсли
