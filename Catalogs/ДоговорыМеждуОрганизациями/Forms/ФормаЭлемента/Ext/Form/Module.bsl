﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);

	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	// Обработчик подсистемы "Свойства"
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	
	// Обработчик подсистемы "Дополнительные отчеты и обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	// Обработчик подсистемы "ВерсионированиеОбъектов"
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	
	// подсистема запрета редактирования ключевых реквизитов объектов	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриЧтенииСозданииНаСервере();
	
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ФиксированнаяСуммаДоговора И Объект.Сумма = 0 Тогда
		
		ТекстОшибки = НСтр("ru='Не заполнена сумма договора.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			Объект.Ссылка,
			"Объект.Сумма",
			,
			Отказ);
	КонецЕсли;
	
	//++ НЕ УТ
	Если Объект.ПлатежиПо275ФЗ Тогда
		Если Объект.ТипДоговора = Перечисления.ТипыДоговоров.СПоставщиком
			И ВариантПлатежаГОЗ = 1 И Не ЗначениеЗаполнено(КонтрактСЗаказчиком) Тогда
			
			Текст = НСтр("ru = 'Поле ""Договор с заказчиком"" не заполнено.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				Текст,
				,
				"КонтрактСЗаказчиком",
				,
				Отказ);
		КонецЕсли;
	КонецЕсли;
	//-- НЕ УТ
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	//++ НЕ УТ
	Если ТекущийОбъект.ПлатежиПо275ФЗ Тогда
		Если ВариантПлатежаГОЗ = 1 Тогда
			ТекущийОбъект.ДоговорыСЗаказчиками.Очистить();
			НоваяСтрока = ТекущийОбъект.ДоговорыСЗаказчиками.Добавить();
			НоваяСтрока.ДоговорСЗаказчиком = КонтрактСЗаказчиком;
		КонецЕсли;
	КонецЕсли;
	//-- НЕ УТ
	
	// Обработчик подсистемы "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьДоступностьЭлементовПоСтатусуСервер();
	
	ОбновитьЗаголовокФормы();
	
	// подсистема запрета редактирования ключевых реквизитов объектов	
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтаФорма);

	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// Подсистема "Свойства"
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
	Если ИмяСобытия = "ИзмененРеквизитЗависящийОтСтатуса"
		И Параметр.УникальныйИдентификатор = УникальныйИдентификатор Тогда
		Если Объект.Согласован Тогда
			Объект.Согласован = Ложь;
		КонецЕсли;
		ПодключитьОбработчикОжидания("Подключаемый_ПриИзмененииРеквизитаЗависящегоОтСтатуса", 0.1, Истина);
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_ПрисоединенныйФайл"
			И Параметр.Свойство("ВладелецФайла")
			И Параметр.ВладелецФайла = Объект.Ссылка
			И Параметр.ЭтоНовый
			И ДобавляетсяФайлПодтверждающегоДокумента Тогда
			
		Элементы.ПодтверждающиеДокументы.ТекущиеДанные.Файл = Источник[0];
		ДобавляетсяФайлПодтверждающегоДокумента = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтатусПриИзменении(Элемент)
	
	Если Объект.Согласован И 
		Объект.Статус <> ПредопределенноеЗначение("Перечисление.СтатусыДоговоровКонтрагентов.Действует")
		И Объект.Статус <> ПредопределенноеЗначение("Перечисление.СтатусыДоговоровКонтрагентов.Закрыт")
	Тогда
		Объект.Согласован = Ложь;
	КонецЕсли;
	
	УстановитьДоступностьЭлементовПоСтатусуСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипДоговораПриИзменении(Элемент)
	
	ТипДоговораПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ЗаполнитьБанковскийСчетОрганизацииПоУмолчанию(Объект.Организация, Объект.ПорядокОплаты, Объект.БанковскийСчет);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПолучательПриИзменении(Элемент)
	
	ЗаполнитьБанковскийСчетОрганизацииПоУмолчанию(Объект.ОрганизацияПолучатель, Объект.ПорядокОплаты, Объект.БанковскийСчетПолучателя);
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядокОплатыПриИзменении(Элемент)
	
	ПорядокОплатыПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаВзаиморасчетовПриИзменении(Элемент)
	
	ВалютаВзаиморасчетовПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, 
		ЭтотОбъект, 
		"Объект.Комментарий");
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	Элементы.НаименованиеДляПечати.СписокВыбора.Очистить();
	Элементы.НаименованиеДляПечати.СписокВыбора.Добавить(Объект.Наименование);
	
КонецПроцедуры

&НаКлиенте
Процедура КлассификацияЗадолженностиПриИзменении(Элемент)
	
	Если КлассификацияЗадолженности = 1 Тогда
		Объект.УстановленСрокОплаты = Истина;
		Объект.СрокОплаты = 366; // Значение больше 365 календарных дней
	Иначе
		Объект.УстановленСрокОплаты = Ложь;
		Объект.СрокОплаты = 0;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПодтверждающиеДокументы

&НаКлиенте
Процедура ПодтверждающиеДокументыВидДокументаПриИзменении(Элемент)
	
	//++ НЕ УТ
	ТекущиеДанные = Элементы.ПодтверждающиеДокументы.ТекущиеДанные;
	
	ЗаполнитьНомерДатаСумма(ТекущиеДанные, Объект);
	//-- НЕ УТ
	
	Возврат;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодтверждающиеДокументыФайлНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	//++ НЕ УТ
	ОписаниеОповещения = Новый ОписаниеОповещения("ПодтверждающиеДокументыФайлНачалоВыбораЗавершение", ЭтотОбъект);
		
	ПунктыМеню = Новый СписокЗначений;
	ТекстВыборИзПрисоединенныхФайлов = НСтр("ru='Выбрать из присоединенных файлов'") + " ...";
	ПунктыМеню.Добавить("ВыборИзПрисоединенныхФайлов", ТекстВыборИзПрисоединенныхФайлов,, БиблиотекаКартинок.ВыбратьЗначение);
	ТекстДобавлениеФайлаСДиска = НСтр("ru='Добавить файл с диска'") + " ...";
	ПунктыМеню.Добавить("ДобавлениеФайлаСДиска", ТекстДобавлениеФайлаСДиска,, БиблиотекаКартинок.ОткрытьФайл);
	
	ПоказатьВыборИзМеню(ОписаниеОповещения, ПунктыМеню, Элементы.ПодтверждающиеДокументыФайл);
	//-- НЕ УТ
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКалькуляцияЗатрат

&НаКлиенте
Процедура КалькуляцияЗатратСуммаПриИзменении(Элемент)
	
	ДанныеКалькуляции = Элементы.КалькуляцияЗатрат.ТекущиеДанные;
	
	Если ДанныеКалькуляции.СуммаКВозмещению > ДанныеКалькуляции.Сумма Тогда
		ДанныеКалькуляции.СуммаКВозмещению = ДанныеКалькуляции.Сумма;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КалькуляцияЗатратСуммаКВозмещениюПриИзменении(Элемент)
	
	ДанныеКалькуляции = Элементы.КалькуляцияЗатрат.ТекущиеДанные;
	
	Если ДанныеКалькуляции.СуммаКВозмещению > ДанныеКалькуляции.Сумма Тогда
		ДанныеКалькуляции.СуммаКВозмещению = ДанныеКалькуляции.Сумма;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьИнтервал(Команда)
	
	ОбщегоНазначенияУТКлиент.РедактироватьПериод(Объект, 
		Новый Структура("ДатаНачала, ДатаОкончания", "ДатаНачалаДействия", "ДатаОкончанияДействия"));
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	ОбщегоНазначенияУТКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтаФорма);
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств(Команда)
	
	УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПодтверждающиеДокументы(Команда)
	
	//++ НЕ УТ
	Оповещение = Новый ОписаниеОповещения("ЗаполнитьПодтверждающиеДокументыЗавершение", 
		ЭтотОбъект);
	ОбщегоНазначенияУТКлиент.ПроверитьВозможностьЗаполненияТабличнойЧасти(
		Оповещение,
		ЭтаФорма,
		Объект.ПодтверждающиеДокументы,
		,
		Ложь);
	//-- НЕ УТ
	
	Возврат;
	
КонецПроцедуры

&НаКлиенте
Процедура ПросмотретьПодтверждающийДокумент(Команда)
	
	//++ НЕ УТ
	Если Элементы.ПодтверждающиеДокументы.ТекущаяСтрока <> Неопределено Тогда
		Файл = Элементы.ПодтверждающиеДокументы.ТекущиеДанные.Файл;
		
		Если Файл = Неопределено Или Файл.Пустая() Тогда
			ПоказатьПредупреждение(,НСтр("ru= 'Файл подтверждающего документа не указан.'"));
			Возврат;
		КонецЕсли;
		
		РеквизитыФайла = РеквизитыОбъекта(Файл);
		
		Если РеквизитыФайла.Зашифрован Тогда
			Возврат;
		КонецЕсли;
		
		ДанныеФайла = ПолучитьДанныеФайла(Файл, УникальныйИдентификатор);
		ПрисоединенныеФайлыКлиент.ОткрытьФайл(ДанныеФайла, РеквизитыФайла.ФайлРедактируется);
	КонецЕсли;
	//-- НЕ УТ
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

//++ НЕ УТ
&НаСервере
Процедура ИнициализироватьВариантПлатежаГОЗ()
	
	Если Объект.ПлатежиПо275ФЗ И Объект.ДоговорСУчастникомГОЗ Тогда
		ВариантПлатежаГОЗ = 1;
	ИначеЕсли Объект.ОплатаРасходовПоТарифамСГосрегулированием Тогда
		ВариантПлатежаГОЗ = 2;
	Иначе
		ВариантПлатежаГОЗ = 0;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодтверждающиеДокументыФайлНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ДополнительныеПараметрыВыбораВладельца = Новый Структура("Действие", Результат.Значение);
		
		ВыборВладельцаФайлаЗавершение(Новый Структура("Значение", Объект.Ссылка), ДополнительныеПараметрыВыбораВладельца);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборВладельцаФайлаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ВыбранныйВладелецФайла = Результат.Значение;
		
		Если ДополнительныеПараметры.Действие = "ДобавлениеФайлаСДиска" Тогда
			
			ИдентификаторФайла = Новый УникальныйИдентификатор;
			ДобавляетсяФайлПодтверждающегоДокумента = Истина;
			
			ПрисоединенныеФайлыКлиент.ДобавитьФайлы(ВыбранныйВладелецФайла, ИдентификаторФайла);
			
		ИначеЕсли ДополнительныеПараметры.Действие = "ВыборИзПрисоединенныхФайлов" Тогда
			
			ПрисоединенныеФайлыКлиент.ОткрытьФормуВыбораФайлов(ВыбранныйВладелецФайла, Элементы.ПодтверждающиеДокументыФайл);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

//-- НЕ УТ

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Изменить", "Доступность", Ложь);
	
	ПоддержкаПлатежей275ФЗ = ПолучитьФункциональнуюОпцию("ПоддержкаПлатежейВСоответствииС275ФЗ");
	
	Если НЕ ЗначениеЗаполнено(Объект.ВалютаВзаиморасчетов) Тогда
		Объект.ВалютаВзаиморасчетов = ДоходыИРасходыСервер.ПолучитьВалютуУправленческогоУчета();
	КонецЕсли;
	
	ФиксированнаяСуммаДоговора = (Объект.Сумма <> 0);
	
	//++ НЕ УТ
	Если Объект.ДоговорыСЗаказчиками.Количество() Тогда
		КонтрактСЗаказчиком = Объект.ДоговорыСЗаказчиками[0].ДоговорСЗаказчиком;
	КонецЕсли;
	
	ИнициализироватьВариантПлатежаГОЗ();
	//-- НЕ УТ
	
	ПараметрыВыбораБанковскогоСчета = ПараметрыВыбораБанковскихСчетов(Объект.ПорядокОплаты);
	Элементы.БанковскийСчет.ПараметрыВыбора            = ПараметрыВыбораБанковскогоСчета;
	Элементы.БанковскийСчетПолучателя.ПараметрыВыбора  = ПараметрыВыбораБанковскогоСчета;
	ДенежныеСредстваСервер.УстановитьПараметрыВыбораСтавкиНДС(Элементы.СтавкаНДС);
	
	НастроитьПараметрыВыбораСтатьиДвиженияДенежныхСредств();
	
	УстановитьДоступностьЭлементовПоСтатусуСервер();
	
	УправлениеЭлементамиГрафикИсполнения(Элементы, ФиксированнаяСуммаДоговора);
	
	//++ НЕ УТ
	УправлениеЭлементамиГосКонтрактов();
	
	ТекущийПользователь = Пользователи.АвторизованныйПользователь();
	КоличествоДопСоглашенийНаМоментОткрытия = КоличествоДопСоглашений();
	
	УстановитьЗаголовкиВалюты();
	УстановитьВидимостьОтчетовГОЗ();
	//-- НЕ УТ
	
	ОбновитьЗаголовокФормы();
	
	Перечисления.ПорядокОплатыПоСоглашениям.ЗаполнитьВозможныеПорядкиОплаты(Объект.ВалютаВзаиморасчетов,Элементы.ПорядокОплаты, Объект.ПорядокОплаты);
	
	Элементы.НаименованиеДляПечати.СписокВыбора.Очистить();
	Элементы.НаименованиеДляПечати.СписокВыбора.Добавить(Объект.Наименование);
	
	Перечисления.ПорядокОплатыПоСоглашениям.ЗаполнитьВозможныеПорядкиОплаты(Объект.ВалютаВзаиморасчетов, Элементы.ПорядокОплаты, Объект.ПорядокОплаты);
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаКлиенте
Процедура ФиксированнаяСуммаДоговораПриИзменении(Элемент)
	
	Если Не ФиксированнаяСуммаДоговора Тогда
		Объект.Сумма = 0;
	КонецЕсли;
	
	УправлениеЭлементамиГрафикИсполнения(Элементы, ФиксированнаяСуммаДоговора);
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантПлатежаГОЗПриИзменении(Элемент)
	
	//++ НЕ УТ
	Объект.ПлатежиПо275ФЗ = (ВариантПлатежаГОЗ <> 0);
	Объект.ДоговорСУчастникомГОЗ = (ВариантПлатежаГОЗ = 1);
	Объект.ОплатаРасходовПоТарифамСГосрегулированием = (ВариантПлатежаГОЗ = 2);
	
	ВариантПлатежаГОЗПриИзмененииНаСервере();
	//-- НЕ УТ
	
	Возврат;
	
КонецПроцедуры

&НаКлиенте
Процедура ГосударственныйКонтрактПриИзменении(Элемент)
	
	//++ НЕ УТ
	ГосударственныйКонтрактПриИзмененииСервер();
	//-- НЕ УТ
	
	Возврат;
	
КонецПроцедуры

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

//++ НЕ УТ
&НаКлиенте
Процедура ЗаполнитьПодтверждающиеДокументыЗавершение(Результат, ДополнительныеПараметры) Экспорт 
	
	ЗаполнитьПодтверждающиеДокументыСервер();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПодтверждающиеДокументыСервер()
	
	ДенежныеСредстваСервер.ЗаполнитьПодтверждающиеДокументы(Объект, Объект.ПодтверждающиеДокументы);
	
	Для Каждого ПодтверждающийДокумент Из Объект.ПодтверждающиеДокументы Цикл
		ЗаполнитьНомерДатаСумма(ПодтверждающийДокумент, Объект);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста 
Процедура ЗаполнитьНомерДатаСумма(ДанныеСтроки, Объект)
	Если Не ДанныеСтроки = Неопределено Тогда
		Если ДанныеСтроки.ВидДокумента = ПредопределенноеЗначение("Справочник.ВидыПодтверждающихДокументов.Контракт") Тогда
			ЗаполнитьЗначенияСвойств(ДанныеСтроки, Объект, "Номер, Дата, Сумма");
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция РеквизитыОбъекта(ПодтверждающийДокумент)
	РеквизитыОбъекта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ПодтверждающийДокумент, "Зашифрован, Редактирует");
	
	ФайлРедактируется = ЗначениеЗаполнено(РеквизитыОбъекта.Редактирует)
	                  И РеквизитыОбъекта.Редактирует = ТекущийПользователь;
	РеквизитыОбъекта.Вставить("ФайлРедактируется", ФайлРедактируется);
		
	Возврат РеквизитыОбъекта;
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьДанныеФайла(Знач ПрисоединенныйФайл,
                            Знач ИдентификаторФормы = Неопределено,
                            Знач ПолучатьСсылкуНаДвоичныеДанные = Истина)
	
	Возврат ПрисоединенныеФайлы.ПолучитьДанныеФайла(
		ПрисоединенныйФайл, ИдентификаторФормы, ПолучатьСсылкуНаДвоичныеДанные);
	
КонецФункции
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
//-- НЕ УТ

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеЭлементамиГрафикИсполнения(Элементы, ФиксированнаяСуммаДоговора)
	
	Элементы.Сумма.Доступность = ФиксированнаяСуммаДоговора;
	Элементы.Сумма.АвтоОтметкаНезаполненного = ФиксированнаяСуммаДоговора;
	
КонецПроцедуры

//++ НЕ УТ
&НаСервере
Процедура УправлениеЭлементамиГосКонтрактов()
	
	ВозможныПлатежи275ФЗ = (Объект.ТипДоговора = Перечисления.ТипыДоговоровМеждуОрганизациями.КупляПродажа);
	
	Элементы.ИдентификаторГосКонтракта.Видимость = НЕ ПоддержкаПлатежей275ФЗ И ВозможныПлатежи275ФЗ;
	
	Элементы.ПодтверждающиеДокументы.Видимость = ВозможныПлатежи275ФЗ И Объект.ПлатежиПо275ФЗ;
	
	// Специфика заказчика
	Элементы.ВыполненыОбязательстваПоДоговоруГОЗ.Видимость = (ВозможныПлатежи275ФЗ И Объект.ДоговорСУчастникомГОЗ);
	
	Элементы.КалькуляцияЗатрат.Видимость = (ВозможныПлатежи275ФЗ И Объект.ДоговорСУчастникомГОЗ);
	Элементы.СуммаПрибыли.Видимость = (ВозможныПлатежи275ФЗ И Объект.ДоговорСУчастникомГОЗ);
	
	// Специфика исполнителя
	Элементы.ВариантПлатежаПрочемуИсполнителю.Видимость = ВозможныПлатежи275ФЗ И ПоддержкаПлатежей275ФЗ;
	Элементы.ВариантПлатежаУчастникуКооперации.Видимость = ВозможныПлатежи275ФЗ И ПоддержкаПлатежей275ФЗ;
	Элементы.ВариантПлатежаПоТарифам.Видимость = ВозможныПлатежи275ФЗ И ПоддержкаПлатежей275ФЗ;
	
	Элементы.ГосударственныйКонтракт.Видимость =
		(ВозможныПлатежи275ФЗ И Объект.ПлатежиПо275ФЗ И Объект.ДоговорСУчастникомГОЗ);
		
	Элементы.КонтрактСЗаказчиком.Видимость = (ВариантПлатежаГОЗ = 1 И ВозможныПлатежи275ФЗ);
	Элементы.СтатьяКалькуляции.Видимость = (ВариантПлатежаГОЗ = 2 И ВозможныПлатежи275ФЗ);
	
	УстановитьПараметрыВыбораДоговораСЗаказчиком();
	УстановитьВидимостьОтчетовГОЗ();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыВыбораДоговораСЗаказчиком()
	
	// Отберем контракты, в которых организация-покупатель является организацией-поставщиком
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Организация", Объект.ОрганизацияПолучатель);
	Если ВариантПлатежаГОЗ = 1 Тогда
		ДополнительныеПараметры.Вставить("ГосударственныйКонтракт", Объект.ГосударственныйКонтракт);
	КонецЕсли;
	
	ДенежныеСредстваСервер.УстановитьПараметрыВыбораДоговораСЗаказчиком(Элементы.КонтрактСЗаказчиком, ДополнительныеПараметры);
	
КонецПроцедуры

&НаСервере
Процедура ВариантПлатежаГОЗПриИзмененииНаСервере()
	
	УправлениеЭлементамиГосКонтрактов();
	УстановитьПараметрыВыбораДоговораСЗаказчиком();
	
КонецПроцедуры

&НаСервере
Процедура ГосударственныйКонтрактПриИзмененииСервер()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Ссылка
	|ИЗ
	|	Справочник.ДоговорыКонтрагентов
	|ГДЕ
	|	ГосударственныйКонтракт = &Госконтракт
	|	И ТипДоговора = ЗНАЧЕНИЕ(Перечисление.ТипыДоговоров.СПокупателем)
	|	И НЕ ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Ссылка
	|ИЗ
	|	Справочник.ДоговорыМеждуОрганизациями
	|ГДЕ
	|	ГосударственныйКонтракт = &Госконтракт
	|	И НЕ ПометкаУдаления
	|";
	Запрос.УстановитьПараметр("Госконтракт", Объект.ГосударственныйКонтракт);
	
	Результат = Запрос.Выполнить().Выгрузить();
	Если Результат.Количество() = 1 Тогда
		КонтрактСЗаказчиком = Результат[0].Ссылка;
	КонецЕсли;
	
	УстановитьПараметрыВыбораДоговораСЗаказчиком();
	
КонецПроцедуры

&НаСервере
Функция КоличествоДопСоглашений()
	Отбор = Новый Структура("ВидДокумента", Справочники.ВидыПодтверждающихДокументов.ДополнительноеСоглашение);
	НайденныеСтроки = Объект.ПодтверждающиеДокументы.НайтиСтроки(Отбор);
	
	Возврат НайденныеСтроки.Количество();
КонецФункции

&НаСервере
Процедура УстановитьЗаголовкиВалюты()
	
	ЧастиЗаголовка = Новый Массив;
	ЧастиЗаголовка.Добавить(НСтр("ru='Сумма'"));
	ЧастиЗаголовка.Добавить("(" + Строка(Объект.ВалютаВзаиморасчетов) + ")");
	
	Элементы.КалькуляцияЗатратСумма.Заголовок = СтрСоединить(ЧастиЗаголовка, Символы.НПП);
	
	ЧастиЗаголовка = Новый Массив;
	ЧастиЗаголовка.Добавить(НСтр("ru='Сумма к возмещению'"));
	ЧастиЗаголовка.Добавить("(" + Строка(Объект.ВалютаВзаиморасчетов) + ")");
	
	Элементы.КалькуляцияЗатратСуммаКВозмещению.Заголовок = СтрСоединить(ЧастиЗаголовка, Символы.НПП);
	
	ЧастиЗаголовка = Новый Массив;
	ЧастиЗаголовка.Добавить(НСтр("ru='Сумма прибыли'"));
	ЧастиЗаголовка.Добавить("(" + Строка(Объект.ВалютаВзаиморасчетов) + ")");
	
	Элементы.СуммаПрибыли.Заголовок = СтрСоединить(ЧастиЗаголовка, Символы.НПП);
	
КонецПроцедуры

&НаСервере 
Процедура УстановитьВидимостьОтчетовГОЗ()
	
	ЭтоДоговорСПокупателем = (Объект.ТипДоговора = Перечисления.ТипыДоговоровМеждуОрганизациями.КупляПродажа);
	
	МенюОтчеты.УстановитьВидимостьЭлементаФормыСервер(ЭтаФорма, "Отчет.ПаспортКонтракта", Объект.ПлатежиПо275ФЗ И ЭтоДоговорСПокупателем);
	МенюОтчеты.УстановитьВидимостьЭлементаФормыСервер(ЭтаФорма, "Отчет.СведенияОКооперации", Объект.ПлатежиПо275ФЗ И ЭтоДоговорСПокупателем);
	
КонецПроцедуры
//-- НЕ УТ

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	
	//++ НЕ УТ
	ВидыПодтверждающиеИсполнениеКонтракта = Новый СписокЗначений;
	ВидыПодтверждающиеИсполнениеКонтракта.ЗагрузитьЗначения(
		Справочники.ВидыПодтверждающихДокументов.ВидыПодтверждающиеИсполнениеКонтракта());

	// Текст незаполненного файла - "<Файл указывается в заявке>"

	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПодтверждающиеДокументыФайл.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ПодтверждающиеДокументы.Файл");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru= '<Указывается в заявке>'"));
	
	// Текст номера и даты для документов, подтверждающих исполнение контракта

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПодтверждающиеДокументыНомер.Имя);
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПодтверждающиеДокументыДата.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ПодтверждающиеДокументы.ВидДокумента");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке;
	ОтборЭлемента.ПравоеЗначение = ВидыПодтверждающиеИсполнениеКонтракта;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Серый);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru= '<Указывается в заявке>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	//-- НЕ УТ
	
КонецПроцедуры

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура ТипДоговораПриИзмененииСервер()
	
	Если Объект.ТипДоговора = Перечисления.ТипыДоговоровМеждуОрганизациями.КупляПродажа Тогда
		Элементы.ГруппаОрганизация.Заголовок = "Поставщик";
		Элементы.ГруппаОрганизацияПолучатель.Заголовок = "Покупатель";
	Иначе
		Элементы.ГруппаОрганизация.Заголовок = "Комитент";
		Элементы.ГруппаОрганизацияПолучатель.Заголовок = "Комиссионер";
	КонецЕсли;
	
	ОбновитьЗаголовокФормы();
	
	//++ НЕ УТ
	ИнициализироватьВариантПлатежаГОЗ();
	УправлениеЭлементамиГосКонтрактов();
	//-- НЕ УТ
КонецПроцедуры

&НаСервере
Процедура ПорядокОплатыПриИзмененииСервер()
	
	Если Объект.ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.РасчетыВРубляхОплатаВРублях 
		ИЛИ Объект.ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.РасчетыВРубляхОплатаВВалюте Тогда
		Объект.ВалютаВзаиморасчетов = Константы.ВалютаРегламентированногоУчета.Получить();
	ИначеЕсли Объект.ВалютаВзаиморасчетов = Константы.ВалютаРегламентированногоУчета.Получить() Тогда
		Объект.ВалютаВзаиморасчетов = Справочники.Валюты.ПустаяСсылка();
	КонецЕсли;
	
	ПараметрыВыбораБанковскихСчетов = ПараметрыВыбораБанковскихСчетов(Объект.ПорядокОплаты);
	Элементы.БанковскийСчет.ПараметрыВыбора            = ПараметрыВыбораБанковскихСчетов;
	Элементы.БанковскийСчетПолучателя.ПараметрыВыбора = ПараметрыВыбораБанковскихСчетов;
	
	Если НЕ БанковскийСчетСоответствуетПорядкуОплаты(Объект.БанковскийСчет, Объект.ПорядокОплаты) Тогда
		Объект.БанковскийСчет = Неопределено;
	КонецЕсли;
	ЗаполнитьБанковскийСчетОрганизацииПоУмолчанию(Объект.Организация, Объект.ПорядокОплаты, Объект.БанковскийСчет);
	
	Если НЕ БанковскийСчетСоответствуетПорядкуОплаты(Объект.БанковскийСчетПолучателя, Объект.ПорядокОплаты) Тогда
		Объект.БанковскийСчетПолучателя = Неопределено;
	КонецЕсли;
	ЗаполнитьБанковскийСчетОрганизацииПоУмолчанию(Объект.ОрганизацияПолучатель, Объект.ПорядокОплаты, Объект.БанковскийСчетПолучателя);
	
КонецПроцедуры

&НаСервере
Процедура ВалютаВзаиморасчетовПриИзмененииСервер()
	
	ВалютаОплатыРегл = ?(Объект.ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.РасчетыВВалютеОплатаВВалюте ИЛИ 
					Объект.ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.РасчетыВРубляхОплатаВВалюте, Ложь ,Неопределено);
					
	Объект.ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.ПолучитьПорядокОплатыПоУмолчанию(Объект.ВалютаВзаиморасчетов,,ВалютаОплатыРегл);
	
	ПорядокОплатыПриИзмененииСервер();
	
	Перечисления.ПорядокОплатыПоСоглашениям.ЗаполнитьВозможныеПорядкиОплаты(Объект.ВалютаВзаиморасчетов, Элементы.ПорядокОплаты, Объект.ПорядокОплаты);

	
	ПорядокОплатыПриИзмененииСервер();
	
КонецПроцедуры

#КонецОбласти

#Область КонтрольНесогласованныхИзменений

&НаКлиенте
Процедура КонтрольНеСогласованныхИзмененийОбработатьСобытиеПриИзменении(Элемент)
	Если Элемент.Имя = "ОрганизацияПолучатель" Тогда
		ОрганизацияПолучательПриИзменении(Элемент);
	ИначеЕсли Элемент.Имя = "Организация" Тогда
		ОрганизацияПриИзменении(Элемент);
	ИначеЕсли Элемент.Имя = "ВалютаВзаиморасчетов" Тогда
		ВалютаВзаиморасчетовПриИзменении(Элемент);
	ИначеЕсли Элемент.Имя = "ПорядокОплаты" Тогда
		ПорядокОплатыПриИзменении(Элемент);
	ИначеЕсли Элемент.Имя = "ТипДоговора" Тогда
		ТипДоговораПриИзменении(Элемент);
	Иначе
		ОбщегоНазначенияУТКлиент.КонтрольНеСогласованныхИзмененийВызватьИсключение(ЭтаФорма, Элемент);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КонтрольНеСогласованныхИзмененийОбработатьСобытиеКоманды(Команда)
	Если Команда.Имя = "УстановитьИнтервал" Тогда
		УстановитьИнтервал(Команда);
	Иначе
		ОбщегоНазначенияУТКлиент.КонтрольНеСогласованныхИзмененийВызватьИсключение(ЭтаФорма, Команда);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КонтрольНеСогласованныхИзмененийОбработатьСобытиеПередНачаломИзменения(Элемент, Отказ)
	
	ОбщегоНазначенияУТКлиент.КонтрольНеСогласованныхИзмененийВызватьИсключение(ЭтаФорма, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрольНеСогласованныхИзмененийОбработатьСобытиеПередУдалением(Элемент, Отказ)
	
	ОбщегоНазначенияУТКлиент.КонтрольНеСогласованныхИзмененийВызватьИсключение(ЭтаФорма, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрольНеСогласованныхИзмененийОбработатьСобытиеПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	ОбщегоНазначенияУТКлиент.КонтрольНеСогласованныхИзмененийВызватьИсключение(ЭтаФорма, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзменении_УстановитьДоступностьЭлементовПоСтатусуСервер(Элемент)
	
	Если ОбщегоНазначенияУТКлиент.ПриДействииСЭлементомЗависящимОтСтатуса(ЭтаФорма) Тогда
		Возврат;
	КонецЕсли;
	
	Если СтруктураДействийКонтрольНеСогласованныхИзменений.ПриИзменении.Свойство(Элемент.Имя) Тогда
		КонтрольНеСогласованныхИзмененийОбработатьСобытиеПриИзменении(Элемент);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_Команда_УстановитьДоступностьЭлементовПоСтатусуСервер(Команда)
	
	Если ОбщегоНазначенияУТКлиент.ПриДействииСЭлементомЗависящимОтСтатуса(ЭтаФорма) Тогда
		Возврат;
	КонецЕсли;
	
	Если СтруктураДействийКонтрольНеСогласованныхИзменений.Команды.Свойство(Команда.Имя) Тогда
		КонтрольНеСогласованныхИзмененийОбработатьСобытиеКоманды(Команда);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПередНачаломИзменения_УстановитьДоступностьЭлементовПоСтатусуСервер(Элемент, Отказ)
	
	Если ОбщегоНазначенияУТКлиент.ПриДействииСЭлементомЗависящимОтСтатуса(ЭтаФорма) Тогда
		Возврат;
	КонецЕсли;
	
	Если СтруктураДействийКонтрольНеСогласованныхИзменений.ПередНачаломИзменения.Свойство(Элемент.Имя) Тогда
		КонтрольНеСогласованныхИзмененийОбработатьСобытиеПередНачаломИзменения(Элемент, Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПередУдалением_УстановитьДоступностьЭлементовПоСтатусуСервер(Элемент, Отказ)
	
	Если ОбщегоНазначенияУТКлиент.ПриДействииСЭлементомЗависящимОтСтатуса(ЭтаФорма) Тогда
		Возврат;
	КонецЕсли;
	
	Имя = Элемент.Имя;
	Если СтруктураДействийКонтрольНеСогласованныхИзменений.ПередУдалением.Свойство(Имя) Тогда
		КонтрольНеСогласованныхИзмененийОбработатьСобытиеПередУдалением(Элемент, Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПередНачаломДобавления_УстановитьДоступностьЭлементовПоСтатусуСервер(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если ОбщегоНазначенияУТКлиент.ПриДействииСЭлементомЗависящимОтСтатуса(ЭтаФорма) Тогда
		Возврат;
	КонецЕсли;
	
	Имя = Элемент.Имя;
	Если СтруктураДействийКонтрольНеСогласованныхИзменений.ПередНачаломДобавления.Свойство(Имя) Тогда
		КонтрольНеСогласованныхИзмененийОбработатьСобытиеПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизитаЗависящегоОтСтатуса()
	
	УстановитьДоступностьЭлементовПоСтатусуСервер();
	ОбщегоНазначенияУТКлиент.ПослеИзмененияРеквизитаЗависящегоОтСтатуса(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьДоступностьЭлементовПоСтатусуСервер()
	
	УстановитьПодписку = Ложь;
	
	Если Объект.Статус = Перечисления.СтатусыДоговоровКонтрагентов.НеСогласован Тогда
		УстановитьПодписку = Ложь;
	ИначеЕсли Объект.Статус = Перечисления.СтатусыДоговоровКонтрагентов.Закрыт Или
		Объект.Статус = Перечисления.СтатусыДоговоровКонтрагентов.Действует Тогда
		УстановитьПодписку = Объект.Согласован;
	КонецЕсли;
	
	МассивЭлементов = Новый Массив;
	
	// Элементы управления шапки
	МассивЭлементов.Добавить("Дата");
	МассивЭлементов.Добавить("Номер");
	МассивЭлементов.Добавить("ДатаНачалаДействия");
	МассивЭлементов.Добавить("ДатаОкончанияДействия");
	МассивЭлементов.Добавить("ОрганизацияПолучатель");
	МассивЭлементов.Добавить("Организация");
	МассивЭлементов.Добавить("ВалютаВзаиморасчетов");
	МассивЭлементов.Добавить("ПорядокОплаты");
	МассивЭлементов.Добавить("ТипДоговора");
	МассивЭлементов.Добавить("ПорядокРасчетов");
	МассивЭлементов.Добавить("УстановитьИнтервал");
	
	ОбщегоНазначенияУТ.УстановитьПодпискуНаСобытияИзмененияЭлементовФормы(ЭтаФорма, МассивЭлементов, УстановитьПодписку);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПараметрыВыбораБанковскихСчетов(ПорядокОплаты)

	МассивПараметров = Новый Массив;
	
	Если ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.РасчетыВРубляхОплатаВРублях
	 ИЛИ ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.РасчетыВВалютеОплатаВРублях Тогда
		МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ВалютаДенежныхСредств", Константы.ВалютаРегламентированногоУчета.Получить()));
	Иначе
		МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.ВалютаДенежныхСредств", Новый ФиксированныйМассив(ИностранныеВалюты())));
	КонецЕсли;
	
	МассивПараметров.Добавить(Новый ПараметрВыбора("ВыборСчетовГоловнойОрганизации", Неопределено));
	
	Возврат Новый ФиксированныйМассив(МассивПараметров);
	
КонецФункции

&НаСервереБезКонтекста
Функция ИностранныеВалюты()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Валюты.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Валюты КАК Валюты
	|ГДЕ
	|	Валюты.Ссылка <> &ВалютаРегламентированногоУчета
	|");
	Запрос.УстановитьПараметр("ВалютаРегламентированногоУчета", Константы.ВалютаРегламентированногоУчета.Получить());
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

&НаСервереБезКонтекста
Функция БанковскийСчетСоответствуетПорядкуОплаты(БанковскийСчет, ПорядокОплаты)

	Соответствует = Истина;
	
	Если ЗначениеЗаполнено(БанковскийСчет) Тогда
		
		ВалютаСчета = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(БанковскийСчет, "ВалютаДенежныхСредств");
		
		Если ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.РасчетыВВалютеОплатаВВалюте Тогда
			Соответствует = ВалютаСчета <> Константы.ВалютаРегламентированногоУчета.Получить();
		Иначе
			Соответствует = ВалютаСчета = Константы.ВалютаРегламентированногоУчета.Получить();
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Соответствует;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ЗаполнитьБанковскийСчетОрганизацииПоУмолчанию(ВладелецСчета, ПорядокОплаты, СчетКЗаполнению)
	
	Если ЗначениеЗаполнено(СчетКЗаполнению)
	 ИЛИ НЕ ЗначениеЗаполнено(ВладелецСчета) Тогда
		Возврат;
	КонецЕсли;
	
	ОплатаВВалюте = ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.РасчетыВВалютеОплатаВВалюте
		ИЛИ ПорядокОплаты = Перечисления.ПорядокОплатыПоСоглашениям.РасчетыВРубляхОплатаВВалюте;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 2
	|	БанковскиеСчетаОрганизаций.Ссылка КАК БанковскийСчет
	|ИЗ
	|	Справочник.БанковскиеСчетаОрганизаций КАК БанковскиеСчетаОрганизаций
	|ГДЕ
	|	БанковскиеСчетаОрганизаций.Владелец = &Организация
	|	И ((БанковскиеСчетаОрганизаций.ВалютаДенежныхСредств = &ВалютаРегл И НЕ &ОплатаВВалюте)
	|	ИЛИ (БанковскиеСчетаОрганизаций.ВалютаДенежныхСредств <> &ВалютаРегл И &ОплатаВВалюте))
	|	И Не БанковскиеСчетаОрганизаций.ПометкаУдаления
	|");
	
	Запрос.УстановитьПараметр("Организация", ВладелецСчета);
	Запрос.УстановитьПараметр("ОплатаВВалюте", ОплатаВВалюте);
	Запрос.УстановитьПараметр("ВалютаРегл", Константы.ВалютаРегламентированногоУчета.Получить());
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Количество() = 1 И Выборка.Следующий() Тогда
		СчетКЗаполнению = Выборка.БанковскийСчет;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЗаголовокФормы()
	
	Если Объект.ТипДоговора = Перечисления.ТипыДоговоровМеждуОрганизациями.КупляПродажа Тогда
		ПредставлениеТипа = НСтр("ru='Договор купли-продажи'");
	ИначеЕсли Объект.ТипДоговора = Перечисления.ТипыДоговоровМеждуОрганизациями.Комиссионный Тогда
		ПредставлениеТипа = НСтр("ru='Договор комиссии'");
	Иначе
		ПредставлениеТипа = ЭтаФорма.Заголовок;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ЭтаФорма.Заголовок = ПредставлениеТипа + " (" + НСтр("ru='создание'") + ")";
	Иначе
		ЭтаФорма.Заголовок = Объект.Наименование + " (" + ПредставлениеТипа + ")";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьПараметрыВыбораСтатьиДвиженияДенежныхСредств()
	
	МассивПараметровВыбора = Новый Массив;
	
	ПараметрВыбора = Новый ПараметрВыбора("Отбор.ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.ПоступлениеОплатыОтКлиента);
	МассивПараметровВыбора.Добавить(ПараметрВыбора);
	Элементы.СтатьяДвиженияДенежныхСредств.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметровВыбора);
	
	МассивПараметровВыбора.Очистить();
	
	ПараметрВыбора = Новый ПараметрВыбора("Отбор.ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.ОплатаПоставщику);
	МассивПараметровВыбора.Добавить(ПараметрВыбора);
	Элементы.СтатьяДвиженияДенежныхСредствПолучателя.ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметровВыбора);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

