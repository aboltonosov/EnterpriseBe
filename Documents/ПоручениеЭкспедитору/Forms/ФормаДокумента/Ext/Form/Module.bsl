﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// Обработчик механизма "Свойства"
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма,
		Новый Структура("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты"));
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
		Объект.ДатаВыполнения = НачалоДня(ТекущаяДатаСеанса());
	КонецЕсли;
	
	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать
	
	МенюОтчеты.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюОтчеты);
	
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
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// Обработчик механизма "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// Обработчик механизма "Свойства"
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_ПоручениеЭкспедитору", ПараметрыЗаписи, Объект.Ссылка);

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементов

&НаКлиенте
Процедура СпособДоставкиПриИзменении(Элемент)
	СпособДоставкиПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура НадписьОснованиеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Объект.Основания.Количество() = 1 Тогда
		ПоказатьЗначение(,Объект.Основания[0].Основание);
	Иначе
	
		Основания = Новый Массив;
		Для Каждого Стр Из Объект.Основания Цикл
			Основания.Добавить(Стр.Основание);
		КонецЦикла;
		
		ОткрытьФорму("ОбщаяФорма.СписокПроизвольныхОбъектовУП",
			Новый Структура("МассивДокументов,ЗаголовокФормы", Основания, НСтр("ru = 'Основания поручения экспедитору'")),,,,,,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АдресПриИзменении(Элемент)
	
	ДоставкаТоваровКлиент.ПриИзмененииПредставленияАдреса(
	    Элемент,
		Объект.АдресДоставки,
		Объект.АдресДоставкиЗначенияПолей);
	
КонецПроцедуры

&НаКлиенте
Процедура АдресНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДоставкаТоваровКлиент.ОткрытьФормуВыбораАдресаИОбработатьРезультат(
	    Элемент,
		Объект,
		"АдресДоставки",
		СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПунктПриИзменении(Элемент)
	ПунктПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура АдресПунктаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДоставкаТоваровКлиент.ПриИзмененииПредставленияАдреса(
	    Элемент,
		Объект.АдресДоставки,
		Объект.АдресДоставкиЗначенияПолей);
	
	Если ДоставкаТоваровКлиентСервер.ДопИнфоИзмененоПользователем(Элементы, Объект)
			И ВыбранноеЗначение.Свойство("ДополнительнаяИнформацияПоДоставке") Тогда
		ЗаполнитьЗначенияСвойств(Объект, ВыбранноеЗначение, , "ДополнительнаяИнформацияПоДоставке");
	Иначе
		ЗаполнитьЗначенияСвойств(Объект, ВыбранноеЗначение);
	КонецЕсли;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПунктНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьВыборИзСписка(Новый ОписаниеОповещения("ПунктНачалоВыбораНачалоВыбораЗавершение", ЭтотОбъект), СписокВыбораПунктов, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	Если Объект.ДатаВыполнения < Объект.Дата Тогда
		Объект.ДатаВыполнения = Объект.Дата;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДополнитьИнформациюПоДоставкеКонтактами(Команда)
	ДополнитьИнформациюПоДоставкеКонтактамиНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ДополнитьОписаниеОснованиями(Команда)
	ДополнитьОписаниеОснованиямиНаСервере();
КонецПроцедуры

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств(Команда)
	
	УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
  Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтотОбъект, Команда.Имя) Тогда
    РезультатВыполнения = Неопределено;
    ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
  КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства
&НаСервере
 Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);
	
 КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	Если Не ЗначениеЗаполнено(Объект.Ответственный) Тогда
		Объект.Ответственный = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
	
	СписокВыбораПунктов.Очистить();
	Если ПравоДоступа("Чтение", Метаданные.Справочники.Партнеры) Тогда
		СписокВыбораПунктов.Добавить(НСтр("ru = '<выбрать партнера>'"));
	КонецЕсли;
	СписокВыбораПунктов.Добавить(НСтр("ru = '<выбрать подразделение>'"));
	СписокВыбораПунктов.Добавить(НСтр("ru = '<выбрать склад>'"));
	СписокВыбораПунктов.Добавить(НСтр("ru = '<ввести произвольный текст>'"));
	
	Если Объект.Основания.Количество() > 0 Тогда
		ДанныеОснований = Документы.ПоручениеЭкспедитору.ДанныеОснований(Объект.Основания.Выгрузить().ВыгрузитьКолонку("Основание"));
		Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
			Если Не ЗначениеЗаполнено(Объект.Пункт)
				И ДанныеОснований.Пункты.Количество() > 0 Тогда
				Объект.Пункт = ДанныеОснований.Пункты[0];
			КонецЕсли;
			Если Не ЗначениеЗаполнено(Объект.Склад) Тогда
				Если ДанныеОснований.Склады.Количество() > 0 Тогда
					Объект.Склад = ДанныеОснований.Склады[0];
				Иначе
					Объект.Склад = Справочники.Склады.СкладПоУмолчанию();
				КонецЕсли;
			КонецЕсли;
			Если Не ЗначениеЗаполнено(Объект.КонтактноеЛицо)
				И ДанныеОснований.Контакты.Количество() > 0 Тогда
				Объект.КонтактноеЛицо = ДанныеОснований.Контакты[0];
			КонецЕсли;
			ПроверитьЗаполнитьКонтактноеЛицо();
		КонецЕсли;
		
		Для Каждого Значение Из ДанныеОснований.Пункты Цикл
			Если ТипЗнч(Значение) = Тип("Строка") Тогда
				ПредставлениеОбъекта = НСтр("ru = 'Текст'");
			Иначе
				ПредставлениеОбъекта = Значение.Метаданные().ПредставлениеОбъекта;
			КонецЕсли;
			
			ПредставлениеЗначения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1: %2'"),
				ПредставлениеОбъекта, Значение);
			СписокВыбораПунктов.Добавить(Значение, ПредставлениеЗначения);
		КонецЦикла;
		Элементы.Склад.СписокВыбора.ЗагрузитьЗначения(ДанныеОснований.Склады);
		Элементы.КонтактноеЛицо.СписокВыбора.ЗагрузитьЗначения(ДанныеОснований.Контакты);
	Иначе
		Элементы.НадписьОснование.Видимость = Ложь;
	КонецЕсли;
	
	ДоставкаТоваров.ПриЧтенииСозданииРаспоряженийНаСервере(Элементы, Объект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка)
		И ЗначениеЗаполнено(Объект.Пункт)
		И Элементы.АдресПункта.СписокВыбора.Количество() > 0 Тогда
		
		ПерваяСтруктураВСписке = Элементы.АдресПункта.СписокВыбора[0].Значение;
		ЗаполнитьЗначенияСвойств(Объект, ПерваяСтруктураВСписке);
		
	КонецЕсли;
	
	УстановитьДоступностьЭлементов();
	ОтобразитьОснование();
	СпособДоставкиПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура СпособДоставкиПриИзмененииНаСервере()
	
	Если Объект.СпособДоставки = Перечисления.СпособыДоставки.ПоручениеЭкспедиторуСоСклада Тогда
		Элементы.ЗаголовокОткуда.Видимость = Истина;
		Элементы.ОтступОткуда.Видимость    = Истина;
		Элементы.Склад.Видимость           = Истина;
		Элементы.ЗаголовокСклад.Видимость  = Истина;
		Элементы.ЗаголовокОткуда.Заголовок = НСтр("ru = 'Откуда'");
		Элементы.ЗаголовокКуда.Заголовок   = НСтр("ru = 'Куда'");
	ИначеЕсли Объект.СпособДоставки = Перечисления.СпособыДоставки.ПоручениеЭкспедиторуНаСклад Тогда
		Элементы.ЗаголовокОткуда.Видимость = Истина;
		Элементы.ОтступОткуда.Видимость    = Истина;
		Элементы.Склад.Видимость           = Истина;
		Элементы.ЗаголовокСклад.Видимость  = Истина;
		Элементы.ЗаголовокОткуда.Заголовок = НСтр("ru = 'Куда'");
		Элементы.ЗаголовокКуда.Заголовок   = НСтр("ru = 'Откуда'");
	Иначе
		Элементы.ЗаголовокОткуда.Видимость = Ложь;
		Элементы.ОтступОткуда.Видимость    = Ложь;
		Элементы.Склад.Видимость           = Ложь;
		Элементы.ЗаголовокСклад.Видимость  = Ложь;
		Элементы.ЗаголовокКуда.Заголовок   = НСтр("ru = 'Где'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьОснование()
	Если Объект.Основания.Количество() = 0 Тогда
		Элементы.НадписьОснование.Заголовок = НСтр("ru = 'Основание'");
		НадписьОснование = НСтр("ru = '<Добавить>'");
	ИначеЕсли Объект.Основания.Количество() = 1 Тогда
		Элементы.НадписьОснование.Заголовок = НСтр("ru = 'Основание'");
		НадписьОснование = Строка(Объект.Основания[0].Основание);
	Иначе
		Элементы.НадписьОснование.Заголовок = НСтр("ru = 'Основания'");
		НадписьОснование = НСтр("ru = 'Всего документов: %Количество'");
		НадписьОснование = СтрЗаменить(НадписьОснование, "%Количество", Объект.Основания.Количество());
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДополнитьИнформациюПоДоставкеКонтактамиНаСервере()
	ДоставкаТоваров.ДополнитьИнформациюПоДоставкеКонтактами(Объект);
КонецПроцедуры

&НаСервере
Процедура ДополнитьОписаниеОснованиямиНаСервере()
	Основания = Объект.Основания.Выгрузить().ВыгрузитьКолонку("Основание");
	ОснованияПоТипам = ОбщегоНазначенияУТ.РазложитьМассивСсылокПоТипам(Основания);
	Для Каждого КлючИЗначение Из ОснованияПоТипам Цикл
		ТекстОснование = Строка(КлючИЗначение.Ключ) + ": ";
		Если КлючИЗначение.Ключ = Тип("Строка") Тогда
			ТекстОснование = КлючИЗначение.Значение + ".";
		Иначе
			Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(КлючИЗначение.Значение, "Номер, Дата");
			ТекстОснование = Строка(КлючИЗначение.Ключ) + ?(КлючИЗначение.Значение.Количество()>1,": "," ");
			Для Каждого КлючИЗначениеРеквизитов Из Реквизиты Цикл
				ТекстНомерИДата = НСтр("ru = '%Номер от %Дата,'") + " ";
				ТекстНомерИДата = СтрЗаменить(ТекстНомерИДата, "%Номер",
					ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(КлючИЗначениеРеквизитов.Значение.Номер));
				ТекстНомерИДата = СтрЗаменить(ТекстНомерИДата, "%Дата",
					Формат(КлючИЗначениеРеквизитов.Значение.Дата,"ДФ=dd.MM.yy"));
				ТекстОснование = ТекстОснование + ТекстНомерИДата;
			КонецЦикла;
			ТекстОснование = Лев(ТекстОснование, СтрДлина(ТекстОснование)-2) + ".";
		КонецЕсли;
		Если СтрНайти(Объект.ОсобыеУсловияПеревозкиОписание, ТекстОснование) = 0 Тогда
			Если Не ПустаяСтрока(Объект.ОсобыеУсловияПеревозкиОписание) Тогда
				Объект.ОсобыеУсловияПеревозкиОписание = Объект.ОсобыеУсловияПеревозкиОписание + Символы.ПС;
			КонецЕсли;
			Объект.ОсобыеУсловияПеревозкиОписание = Объект.ОсобыеУсловияПеревозкиОписание + ТекстОснование;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
  ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтотОбъект, ИмяЭлемента, РезультатВыполнения);
КонецПроцедуры

&НаСервере
Процедура ПунктПриИзмененииНаСервере()
	
	Элементы.АдресПункта.СписокВыбора.Очистить();
	ПустыеРеквизиты = ДоставкаТоваровКлиентСервер.ПолучитьПустуюСтруктуруРеквизитовДоставки(Объект);
	ЗаполнитьЗначенияСвойств(Объект, ПустыеРеквизиты,,"СпособДоставки,ДополнительнаяИнформацияПоДоставке");
	
	Если ЗначениеЗаполнено(Объект.Пункт) Тогда
		
		ДоставкаТоваров.ЗаполнитьСпискиВыбораАдресовПолучателяОтправителя(Элементы, Объект);
		Если Элементы.АдресПункта.СписокВыбора.Количество() > 0 Тогда
			ПерваяСтруктураВСписке = Элементы.АдресПункта.СписокВыбора[0].Значение;
			
			Если ДоставкаТоваровКлиентСервер.ДопИнфоИзмененоПользователем(Элементы, Объект) Тогда
				ЗаполнитьЗначенияСвойств(Объект, ПерваяСтруктураВСписке,
					"АдресДоставки, АдресДоставкиЗначенияПолей, ЗонаДоставки, ВремяДоставкиС, ВремяДоставкиПо");
			Иначе
				ЗаполнитьЗначенияСвойств(Объект, ПерваяСтруктураВСписке);
			КонецЕсли;
			
		КонецЕсли;
				
	КонецЕсли;
	
	ПроверитьЗаполнитьКонтактноеЛицо();
	
	УстановитьДоступностьЭлементов();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьЭлементов()
	
	Элементы.КонтактноеЛицо.Доступность = (ТипЗнч(Объект.Пункт) = Тип("СправочникСсылка.Партнеры"));
	Элементы.ДополнитьИнформациюПоДоставкеКонтактами.Доступность =
		(ТипЗнч(Объект.Пункт) <> Тип("СправочникСсылка.СтруктураПредприятия")
		И ТипЗнч(Объект.Пункт) <> Тип("Строка"));
	Элементы.ДополнитьОписаниеОснованиями.Доступность = (Объект.Основания.Количество() > 0);
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьЗаполнитьКонтактноеЛицо()
	
	Если ТипЗнч(Объект.Пункт) <> Тип("СправочникСсылка.Партнеры") Тогда
		Объект.КонтактноеЛицо = Справочники.КонтактныеЛицаПартнеров.ПустаяСсылка();
		Возврат;
	КонецЕсли;
	ПартнерыИКонтрагенты.ЗаполнитьКонтактноеЛицоПартнераПоУмолчанию(Объект.Пункт, Объект.КонтактноеЛицо);
	
КонецПроцедуры

&НаКлиенте
Процедура ПунктНачалоВыбораНачалоВыбораЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВыбранноеЗначение = ВыбранныйЭлемент.Значение;
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыбораПункта",ЭтотОбъект);
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	ИначеЕсли ВыбранноеЗначение = НСтр("ru = '<выбрать партнера>'") Тогда
		ОткрытьФорму("Справочник.Партнеры.Форма.ФормаВыбора",            ,ЭтаФорма,,,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);	
	ИначеЕсли ВыбранноеЗначение = НСтр("ru = '<выбрать подразделение>'") Тогда
		ОткрытьФорму("Справочник.СтруктураПредприятия.Форма.ФормаВыбора",,ЭтаФорма,,,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ИначеЕсли ВыбранноеЗначение = НСтр("ru = '<выбрать склад>'") Тогда
		ОткрытьФорму("Справочник.Склады.Форма.ФормаВыбора",              ,ЭтаФорма,,,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ИначеЕсли ВыбранноеЗначение = НСтр("ru = '<ввести произвольный текст>'") Тогда
		Объект.Пункт = "";
	Иначе
		Объект.Пункт = ВыбранноеЗначение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораПункта(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Объект.Пункт = ВыбранноеЗначение;	
	ПунктПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти
