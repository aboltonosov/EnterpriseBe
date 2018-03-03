﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обновление версии ИБ".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Вызывается перед обработчиками обновления данных ИБ.
//
Процедура ПередОбновлениемИнформационнойБазы() Экспорт
	
	//++ НЕ ГИСМ
	
	//++ НЕ УТ
	
	ВерсииПодсистем = ОбновлениеИнформационнойБазы.ВерсииПодсистем();
	
	Если ВерсииПодсистем.Количество() > 0 Тогда
		
		Если ВерсииПодсистем.Найти(Метаданные.Имя, "ИмяПодсистемы") = Неопределено Тогда
			
			ОбновлениеИнформационнойБазы.ЗарегистрироватьНовуюПодсистему(Метаданные.Имя, Метаданные.Версия);
			
		КонецЕсли;
		
		Если ВерсииПодсистем.Найти("КомплекснаяАвтоматизация", "ИмяПодсистемы") = Неопределено и Метаданные.Имя = "УправлениеПредприятием" Тогда
			
			Описание = Новый Структура("Имя,Версия,РежимВыполненияОтложенныхОбработчиков");
			
			ОбновлениеИнформационнойБазыКА.ПриДобавленииПодсистемы(Описание);
			
			ОбновлениеИнформационнойБазы.ЗарегистрироватьНовуюПодсистему(Описание.Имя, Описание.Версия);
			
		КонецЕсли;
		
	КонецЕсли;
	
	//-- НЕ УТ
	
	//-- НЕ ГИСМ

КонецПроцедуры

// Вызывается после завершении обновления данных ИБ.
// 
// Параметры:
//   ПредыдущаяВерсияИБ     - Строка - версия ИБ до обновления. "0.0.0.0" для "пустой" ИБ.
//   ТекущаяВерсияИБ        - Строка - версия ИБ после обновления.
//   ВыполненныеОбработчики - ДеревоЗначений - список выполненных процедур-обработчиков
//                                             обновления, сгруппированных по номеру версии.
//  Для перебора выполненных обработчиков:
//		Для Каждого Версия Из ВыполненныеОбработчики.Строки Цикл
//	
//			Если Версия.Версия = "*" Тогда
//				группа обработчиков, которые выполняются всегда.
//			Иначе
//				группа обработчиков, которые выполняются для определенной версии.
//			КонецЕсли;
//	
//			Для Каждого Обработчик Из Версия.Строки Цикл
//				...
//			КонецЦикла;
//	
//		КонецЦикла;
//
//   ВыводитьОписаниеОбновлений - Булево -	если Истина, то выводить форму с описанием 
//											обновлений.
//   МонопольныйРежим           - Булево - признак выполнения обновления в монопольном режиме.
//                                Истина - обновление выполнялось в монопольном режиме.
// 
Процедура ПослеОбновленияИнформационнойБазы(Знач ПредыдущаяВерсияИБ, Знач ТекущаяВерсияИБ,
	Знач ВыполненныеОбработчики, ВыводитьОписаниеОбновлений, МонопольныйРежим) Экспорт
	
КонецПроцедуры

// Вызывается при подготовке табличного документа с описанием изменений программы.
//
// Параметры:
//   Макет - ТабличныйДокумент - описание обновлений.
//   
// См. также общий макет ОписаниеИзмененийСистемы.
//
Процедура ПриПодготовкеМакетаОписанияОбновлений(Знач Макет) Экспорт
	
КонецПроцедуры

// Вызывается для получения списка обработчиков обновления, которые нужно пропустить.
// Отключать можно только обработчики обновления с номером версии "*".
//
// Пример добавления отключаемого обработчика в список:
//   НовоеИсключение = ОтключаемыеОбработчики.Добавить();
//   НовоеИсключение.ИдентификаторБиблиотеки = "СтандартныеПодсистемы";
//   НовоеИсключение.Версия = "*";
//   НовоеИсключение.Процедура = "ВариантыОтчетов.Обновить";
//
// Версия - номер версии конфигурации, в которой нужно отключить
//          выполнение обработчика.
//
Процедура ПриОтключенииОбработчиковОбновления(ОтключаемыеОбработчики) Экспорт
	
КонецПроцедуры

// Позволяет переопределить очередь отложенных обработчиков обновления, выполняемых в
// параллельном режиме.
//
// Параметры:
//  ОбработчикИОчередь - Соответствие, где:
//    * Ключ     - Строка - полное имя обработчика обновления.
//    * Значение - Число  - номер очереди, который необходимо установить обработчику.
//
Процедура ПриФормированииОчередейОтложенныхОбработчиков(ОбработчикИОчередь) Экспорт

	ОбработчикИОчередь.Вставить("РегистрыНакопления.ОстаткиАлкогольнойПродукцииЕГАИС.ОбработатьДанныеДляПереходаНаНовуюВерсию", 1);

КонецПроцедуры

// Позволяет переопределить различные сообщения, выводимые пользователю.
// 
// Параметры:
//  Параметры - Структура со свойствами:
//    * ПоясненияДляРезультатовОбновления - Строка - текст подсказки, указывающий путь
//                                          к форме "Результаты обновления программы".
//    * ПараметрыСообщенияОНевыполненныхОтложенныхОбработчиках - Структура - сообщение о
//                                          наличии невыполненных отложенных обработчиков обновления
//                                          на прошлую версию при попытке обновления.
//       * ТекстСообщения                 - Строка - текст сообщения, выводимый пользователю. По умолчанию
//                                          текст сообщения построен с учетом того, что обновление можно
//                                          продолжить, т.е. параметр ЗапрещатьПродолжение = Ложь.
//       * КартинкаСообщения              - БиблиотекаКартинок: Картинка - картинка, выводимая слева от сообщения.
//       * ЗапрещатьПродолжение           - Булево - если Истина, продолжить обновление будет невозможно. По умолчанию Ложь.
//    * РасположениеОписанияИзмененийПрограммы - Строка - описывает расположение команды, по которой можно
//                                          открыть форму с описанием изменений в новой версии программы.
//
Процедура ПриОпределенииНастроек(Параметры) Экспорт
	
	//++ НЕ ГИСМ
	
	Параметры.Вставить("ПоясненияДляРезультатовОбновления", НСтр("ru = 'Сведения о результатах обновления версии программы можно также открыть из раздела ""НСИ и администрирование"" - ""Интернет-поддержка пользователей"".'"));
	
	//-- НЕ ГИСМ
	
КонецПроцедуры

#КонецОбласти
