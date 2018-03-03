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
	
	ЗарплатаКадры.ЗаполнитьНаборыПоОрганизацииИФизическимЛицам(ЭтотОбъект, Таблица, "Организация", "ФизическоеЛицо");
	
КонецПроцедуры

// Подсистема "Управление доступом".

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Сотрудники") Тогда
		ЗарплатаКадры.ЗаполнитьПоОснованиюСотрудником(ЭтотОбъект, ДанныеЗаполнения);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Действие") И ДанныеЗаполнения.Действие = "Исправить" Тогда
			
			ИсправлениеДокументовЗарплатаКадры.СкопироватьДокумент(ЭтотОбъект, ДанныеЗаполнения.Ссылка);
			
			ИсправленныйДокумент = ДанныеЗаполнения.Ссылка;
			ЗарплатаКадрыРасширенный.ПриКопированииМногофункциональногоДокумента(ЭтотОбъект);
			
		КонецЕсли;
	КонецЕсли;
	
	ЗарплатаКадрыРасширенный.ОбработкаЗаполненияМногофункциональногоДокумента(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Документы.ОплатаДнейУходаЗаДетьмиИнвалидами.ПровестиПоУчетам(Ссылка, РежимПроведения, Отказ, Неопределено, Движения, ЭтотОбъект, ДополнительныеСвойства);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	КонтейнерОшибок = Неопределено;
	
	ПроверитьЗаполнениеРеквизитовШапки(КонтейнерОшибок);	

	Если ПолучитьФункциональнуюОпцию("ИспользоватьРасчетЗарплатыРасширенная") Тогда
		
		ЗарплатаКадрыРасширенный.ПроверитьУтверждениеДокумента(ЭтотОбъект, Отказ);
		
		Если ДокументРассчитан Тогда
			
			ЗарплатаКадры.ПроверитьДатуВыплаты(ЭтотОбъект, Отказ);
			
			ПроверитьЗаполнениеРеквизитовНеобходимыхДляРасчета(КонтейнерОшибок);                                                                        

			ИсправлениеДокументовЗарплатаКадры.ПроверитьЗаполнение(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ);
			ПроверитьПериодДействияНачислений(Отказ);
			
			// Проверка корректности распределения по источникам финансирования
			ИменаТаблицРаспределяемыхПоСтатьямФинансирования = "Начисления,НачисленияПерерасчет,Удержания,НДФЛ,КорректировкиВыплаты";
			
			ОтражениеЗарплатыВБухучетеРасширенный.ПроверитьРезультатыРаспределенияНачисленийУдержанийОбъекта(
				ЭтотОбъект, ИменаТаблицРаспределяемыхПоСтатьямФинансирования, Отказ);
			
			// Проверка корректности распределения по территориям и условиям труда
			ИменаТаблицРаспределенияПоТерриториямУсловиямТруда = "Начисления,НачисленияПерерасчет";
			
			РасчетЗарплатыРасширенный.ПроверитьРаспределениеПоТерриториямУсловиямТрудаДокумента(
				ЭтотОбъект, ИменаТаблицРаспределенияПоТерриториямУсловиямТруда, Отказ);
			
		КонецЕсли;
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(КонтейнерОшибок, Отказ);
	
	УдалитьПроверенныеРеквизиты(ПроверяемыеРеквизиты);

КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПерерасчетЗарплаты.УдалениеПерерасчетаПоРегистратору(Ссылка);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьСотрудникаВТаблицахНачислений();
	
	ПредставлениеПериода = Документы.ОплатаДнейУходаЗаДетьмиИнвалидами.ПредставлениеПериодаДляДнейУхода(ДниУхода);
	
	ЗарплатаКадрыРасширенный.ПередЗаписьюМногофункциональногоДокумента(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	УчетСреднегоЗаработка.ЗаписатьДатуНачалаСобытия(Ссылка, Сотрудник, ДатаНачалаСобытия);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ЗарплатаКадрыРасширенный.ПриКопированииМногофункциональногоДокумента(ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПроверкаЗаполненияДокумента

Функция ДокументГотовКРасчету(ВыводитьСообщения = Истина) Экспорт
	
	КонтейнерОшибок = Неопределено;
	
	ПроверитьЗаполнениеРеквизитовШапки(КонтейнерОшибок);
	
	ПроверитьЗаполнениеРеквизитовНеобходимыхДляРасчета(КонтейнерОшибок, Истина);                                                                        
		
	КонтейнерСодержитОшибки = Ложь;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(КонтейнерОшибок, КонтейнерСодержитОшибки);
	
	Если Не ВыводитьСообщения Тогда
		
		ПолучитьСообщенияПользователю(Истина);		
		
	КонецЕсли;
	
	Возврат Не КонтейнерСодержитОшибки;	
	
КонецФункции

Процедура ПроверитьЗаполнениеРеквизитовШапки(КонтейнерОшибок)
	
	Если Не ЗначениеЗаполнено(ПериодРегистрации) Тогда
		ТекстСообщения = НСтр("ru = 'Не указан период регистрации.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.ПериодРегистрации", ТекстСообщения, "");
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		ТекстСообщения = НСтр("ru = 'Поле ""Организация"" обязательно к заполнению.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.Организация", ТекстСообщения, "");
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Сотрудник) Тогда
		ТекстСообщения = НСтр("ru = 'Поле ""Сотрудник"" обязательно к заполнению.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.Сотрудник", ТекстСообщения, "");
	КонецЕсли;
	
	Если ДниУхода.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Не указаны дни ухода за детьми-инвалидами.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.ДниУхода", ТекстСообщения, "");
	КонецЕсли;

КонецПроцедуры

Процедура ПроверитьЗаполнениеРеквизитовНеобходимыхДляРасчета(КонтейнерОшибок, ПроверкаПередРасчетом = Ложь)
	
	Если Не ДокументРассчитан И Не ПроверкаПередРасчетом Тогда
		Возврат;
	КонецЕсли;	
	
	Если Не ЗначениеЗаполнено(ВидРасчета) 
		И Не ПолучитьФункциональнуюОпцию("ВыбиратьВидНачисленияОплатыДнейУходаЗаДетьмиИнвалидами") Тогда
		ТекстСообщения = Документы.ОплатаДнейУходаЗаДетьмиИнвалидами.ТекстСообщенияНеЗаполненВидРасчета();
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.ВидРасчета", ТекстСообщения, "");
	КонецЕсли;
	
	ПроверитьЗаполнениеПланируемойДатыВыплаты(КонтейнерОшибок, ПроверкаПередРасчетом);
	
КонецПроцедуры

Процедура ПроверитьЗаполнениеПланируемойДатыВыплаты(КонтейнерОшибок, ПроверкаПередРасчетом)
	
	МассивНачисленийДокумента = Новый Массив;
	
	Если НЕ ПроверкаПередРасчетом Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивНачисленийДокумента, Начисления.ВыгрузитьКолонку("Начисление"), Истина);
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивНачисленийДокумента, НачисленияПерерасчет.ВыгрузитьКолонку("Начисление"), Истина);
	КонецЕсли;
	
	Если УчетНДФЛРасширенный.ДатаВыплатыОбязательнаКЗаполнению(ПорядокВыплаты, МассивНачисленийДокумента)
		И Не ЗначениеЗаполнено(ПланируемаяДатаВыплаты) Тогда
		ТекстСообщения = НСтр("ru = 'Дата выплаты обязательна к заполнению при выплате в межрасчет.'");
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(КонтейнерОшибок, "Объект.ПланируемаяДатаВыплаты", ТекстСообщения, "");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьПериодДействияНачислений(Отказ)
	ПараметрыПроверкиПериодаДействия = РасчетЗарплатыРасширенный.ПараметрыПроверкиПериодаДействия();
	ПараметрыПроверкиПериодаДействия.Ссылка = ЭтотОбъект.Ссылка;
	ПроверяемыеКоллекции = Новый Массив;
	ПроверяемыеКоллекции.Добавить(РасчетЗарплатыРасширенный.ОписаниеКоллекцииДляПроверкиПериодаДействия("НачисленияПерерасчет", НСтр("ru = 'Перерасчет прошлого периода'")));
	ПроверяемыеКоллекции.Добавить(РасчетЗарплатыРасширенный.ОписаниеКоллекцииДляПроверкиПериодаДействия("Удержания", НСтр("ru = 'Удержания'"), "Удержание"));
	РасчетЗарплатыРасширенный.ПроверитьПериодДействияВКоллекцияхНачислений(ЭтотОбъект, ПараметрыПроверкиПериодаДействия, ПроверяемыеКоллекции, Отказ);
КонецПроцедуры

Процедура УдалитьПроверенныеРеквизиты(ПроверяемыеРеквизиты)
	
	Если ПроверяемыеРеквизиты = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Организация");
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Сотрудник");
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ПланируемаяДатаВыплаты");
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ДниУхода");
	ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "ВидРасчета");
	
КонецПроцедуры

#КонецОбласти

Процедура ЗаполнитьСотрудникаВТаблицахНачислений()
	
	ТаблицыНачислений = Новый Массив;
	ТаблицыНачислений.Добавить(Начисления);
	ТаблицыНачислений.Добавить(НачисленияПерерасчет);
	
	Для Каждого ТаблицаНачислений Из ТаблицыНачислений Цикл
		Для Каждого СтрокаТаблицы Из ТаблицаНачислений Цикл
			Если Не ЗначениеЗаполнено(СтрокаТаблицы.Сотрудник) Тогда
				СтрокаТаблицы.Сотрудник = Сотрудник;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли