﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	// Обработчик подсистемы "Дополнительные отчеты и обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	Если Параметры.Свойство("Организация") Тогда
		
		ПоВсемОрганизациям = Параметры.Организация = Справочники.Организации.ПустаяСсылка();
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Организация",
			Параметры.Организация,
			?(ПоВсемОрганизациям,ВидСравненияКомпоновкиДанных.НеРавно, ВидСравненияКомпоновкиДанных.Равно),
			,
			Истина);
		
		Список.АвтоматическоеСохранениеПользовательскихНастроек = Ложь;
		
	КонецЕсли;
	
	Если Параметры.Свойство("ПериодРегистрации") Тогда
		
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
			Список.КомпоновщикНастроек.Настройки.Отбор, "Дата",
			ВидСравненияКомпоновкиДанных.БольшеИлиРавно,
			НачалоМесяца(Параметры.ПериодРегистрации),
			,
			Истина,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный,
			"НачалоПериода");
			
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
			Список.КомпоновщикНастроек.Настройки.Отбор, "Дата",
			ВидСравненияКомпоновкиДанных.МеньшеИлиРавно,
			КонецМесяца(Параметры.ПериодРегистрации),
			,
			Истина,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный,
			"КонецПериода");
			
		Список.АвтоматическоеСохранениеПользовательскихНастроек = Ложь;
		
	КонецЕсли;
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// ВводНаОсновании
	ВводНаОсновании.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюСоздатьНаОсновании);
	// Конец ВводНаОсновании

	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты
	

	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.Дата.Имя);


КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// ВводНаОсновании
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры
// Конец ВводНаОсновании

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры
// Конец МенюОтчеты


// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти
