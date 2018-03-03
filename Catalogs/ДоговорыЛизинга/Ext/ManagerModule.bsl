﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Выполняет поиск действующего договора лизинга для документа.
// Если найден один действующий договор, возвращает ссылку на него, в противном случае - пустую ссылку.
//
// Параметры:
//		Объект - ДокументОбъект.ПоступлениеУслугПоЛизингу - Документ, в котором необходимо заполнить договор по умолчанию.
//
// Возвращаемое значение:
// 		СправочникСсылка.ДоговорыЛизинга - Договор по умолчанию
//
Функция ДоговорПоУмолчанию(Объект) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДоговорыЛизинга.Ссылка КАК Ссылка
	|
	|ИЗ
	|	Справочник.ДоговорыЛизинга КАК ДоговорыЛизинга
	|ГДЕ
	|	(НЕ ДоговорыЛизинга.ПометкаУдаления)
	|	И ДоговорыЛизинга.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыДоговоровКонтрагентов.Действует)
	|	И ДоговорыЛизинга.Контрагент = &Контрагент
	|	И ДоговорыЛизинга.Организация = &Организация
	|	И ДоговорыЛизинга.Ссылка = &ТекущийДоговор
	|;
	|
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
	|	ДоговорыЛизинга.Ссылка КАК Ссылка
	|
	|ИЗ
	|	Справочник.ДоговорыЛизинга КАК ДоговорыЛизинга
	|ГДЕ
	|	(НЕ ДоговорыЛизинга.ПометкаУдаления)
	|	И ДоговорыЛизинга.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыДоговоровКонтрагентов.Действует)
	|	И ДоговорыЛизинга.Контрагент = &Контрагент
	|	И ДоговорыЛизинга.Организация = &Организация
	|";
	Запрос.УстановитьПараметр("ТекущийДоговор", Объект.Договор);
	Запрос.УстановитьПараметр("Контрагент",		Объект.Контрагент);
	Запрос.УстановитьПараметр("Организация",	Объект.Организация);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	Если Не МассивРезультатов[0].Пустой() Тогда
		
		Выборка = МассивРезультатов[0].Выбрать();
		Выборка.Следующий();
		
		ДоговорПоУмолчанию = Выборка.Ссылка;
		
	Иначе
		Выборка = МассивРезультатов[1].Выбрать();
	
		Если Не Выборка.Следующий() Тогда
			ДоговорПоУмолчанию = Справочники.ДоговорыЛизинга.ПустаяСсылка();
		ИначеЕсли Выборка.Количество() = 1 Тогда
			ДоговорПоУмолчанию = Выборка.Ссылка;
		Иначе
			ДоговорПоУмолчанию = Справочники.ДоговорыЛизинга.ПустаяСсылка();
		КонецЕсли;
	КонецЕсли;
	
	Возврат ДоговорПоУмолчанию;
	
КонецФункции

// Возвращает имена блокируемых реквизитов для механизма блокирования реквизитов БСП
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("Партнер");
	Результат.Добавить("Контрагент");
	Результат.Добавить("Организация");
	Результат.Добавить("ПорядокОплаты");
	Результат.Добавить("ВалютаВзаиморасчетов");
	
	Результат.Добавить("ВариантУчетаИмущества");
	Результат.Добавить("ЕстьОбеспечительныйПлатеж");
	Результат.Добавить("ЕстьВыкупПредметаЛизинга");
	
	Возврат Результат;
	
КонецФункции

// Возвращает доступные типы начислений по договору лизинга
//
// Параметры:
// 	Договор - СправочникСсылка.ДоговорыЛизинга - Договор лизинга
//
// Возвращаемое значение:
// 	Результат - Массив - Типы начислений доступные по договору лизинга
//
Функция ТипыНачисленийПоДоговору(Договор) Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить(Перечисления.ТипыНачисленийПоЛизингу.УслугаПоЛизингу);
	
	Если НЕ ЗначениеЗаполнено(Договор) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Реквизиты = "ЕстьОбеспечительныйПлатеж, ЕстьВыкупПредметаЛизинга";
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Договор, Реквизиты);
	
	Если ЗначенияРеквизитов.ЕстьОбеспечительныйПлатеж Тогда
		Результат.Добавить(Перечисления.ТипыНачисленийПоЛизингу.ЗачетОбеспечительногоПлатежа);
	КонецЕсли;
	
	Если ЗначенияРеквизитов.ЕстьВыкупПредметаЛизинга Тогда
		Результат.Добавить(Перечисления.ТипыНачисленийПоЛизингу.ВыкупПредметаЛизинга);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Возвращает доступные типы платежей по договору лизинга
//
// Параметры:
// 	Договор - СправочникСсылка.ДоговорыЛизинга - Договор лизинга
//
// Возвращаемое значение:
// 	Результат - Массив - Типы начислений доступные по договору лизинга
//
Функция ТипыПлатежейПоДоговору(Договор) Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить(Перечисления.ТипыПлатежейПоЛизингу.ЛизинговыйПлатеж);
	
	Если НЕ ЗначениеЗаполнено(Договор) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Реквизиты = "ЕстьОбеспечительныйПлатеж, ЕстьВыкупПредметаЛизинга";
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Договор, Реквизиты);
	
	Если ЗначенияРеквизитов.ЕстьОбеспечительныйПлатеж Тогда
		Результат.Добавить(Перечисления.ТипыПлатежейПоЛизингу.ОбеспечительныйПлатеж);
	КонецЕсли;
	
	Если ЗначенияРеквизитов.ЕстьВыкупПредметаЛизинга Тогда
		Результат.Добавить(Перечисления.ТипыПлатежейПоЛизингу.ВыкупПредметаЛизинга);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ОсновноеСредство") И ЗначениеЗаполнено(Параметры.ОсновноеСредство) Тогда
		Параметры.Отбор.Вставить("НаправлениеДеятельности", ВнеоборотныеАктивыВызовСервера.НаправлениеДеятельности(Параметры.ОсновноеСредство));
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ОсновноеСредство") И ЗначениеЗаполнено(Параметры.ОсновноеСредство) Тогда
		Параметры.Отбор.Вставить("НаправлениеДеятельности", ВнеоборотныеАктивыВызовСервера.НаправлениеДеятельности(Параметры.ОсновноеСредство));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Отчеты

// Заполняет список команд отчетов.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов) Экспорт

	//++ НЕ УТ
	ВариантыОтчетовУТПереопределяемый.ДобавитьКомандуРасчетыПоДоговору(КомандыОтчетов);
	//-- НЕ УТ

КонецПроцедуры

#КонецОбласти

#Область Печать

Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли