﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	// Очистка неиспользуемых реквизитов и заполнение служебных
	Если ПравилаОтправкиСправочников = "НеСинхронизировать" Тогда
		
		ИспользоватьОтборПоОрганизациям = Ложь;
		РежимВыгрузкиСправочников       = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать;
		РежимВыгрузкиПриНеобходимости   = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать;
		
	Иначе
		
		РежимВыгрузкиПриНеобходимости    = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости;

		Если ПравилаОтправкиСправочников = "СинхронизироватьПоНеобходимости" Тогда
			РежимВыгрузкиСправочников = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости;
		Иначе
			РежимВыгрузкиСправочников       = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ПравилаОтправкиДокументов = "НеСинхронизировать" Тогда
		РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать;
	ИначеЕсли ПравилаОтправкиДокументов = "ИнтерактивнаяСинхронизация" Тогда
		РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьВручную;
	Иначе
		РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию;
	КонецЕсли;
	
	Если Не ИспользоватьОтборПоОрганизациям И Организации.Количество() <> 0 Тогда
		Организации.Очистить();
	ИначеЕсли Организации.Количество() = 0 И ИспользоватьОтборПоОрганизациям Тогда
		ИспользоватьОтборПоОрганизациям = Ложь;
	КонецЕсли;
	
	Если ПравилаОтправкиДокументов <> "АвтоматическаяСинхронизация" Тогда
		ДатаНачалаВыгрузкиДокументов = Дата(1,1,1,0,0,0);
	КонецЕсли;
	
	ОбменДаннымиСобытияУТУП.ОбновитьКэшМеханизмовРегистрации();
	
КонецПроцедуры // ПередЗаписью()

#КонецОбласти

#КонецЕсли
