﻿&НаКлиенте
Перем ВыполняетсяЗакрытие;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("СписокДокументов", СписокДокументов);
	
	Если Параметры.ЕстьОшибки Тогда
		Для Каждого ТекОшибка Из Параметры.МассивОшибок Цикл
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Строка(ТекОшибка.КлючДанных) + ". " + ТекОшибка.Текст,
																ТекОшибка.КлючДанных, ТекОшибка.Поле, ТекОшибка.ПутьКДанным);
		КонецЦикла;
	КонецЕсли;
	
	СклонениеСлова = ОбщегоНазначенияУТКлиентСервер.СклонениеСлова(
		СписокДокументов.Количество(),
		НСтр("ru = 'документ'"),
		НСтр("ru = 'документа'"),
		НСтр("ru = 'документов'"),
		"м");
	
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		Заголовок,
		НСтр("ru = 'Оформление производства без заказов'"),
		СписокДокументов.Количество(),
		СклонениеСлова);
	
	ОбновитьОтборы();
	
	ОбъектыМетаданных = Новый Массив;
	ОбъектыМетаданных.Добавить(Метаданные.Документы.ПроизводствоБезЗаказа);
	ОбъектыМетаданных.Добавить(Метаданные.Документы.РаспределениеВозвратныхОтходов);
	
	// СтандартныеПодсистемы.ВводНаОсновании
	ВводНаОсновании.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюСоздатьНаОсновании, ОбъектыМетаданных);
	// Конец СтандартныеПодсистемы.ВводНаОсновании

	// СтандартныеПодсистемы.ВнешниеОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВнешниеОбработки
	
	// СтандартныеПодсистемы.МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты, ОбъектыМетаданных);
	// Конец СтандартныеПодсистемы.МенюОтчеты
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать, ОбъектыМетаданных);
	// Конец СтандартныеПодсистемы.Печать
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Не ВыполняетсяЗакрытие И ДокументыНеОбработаны(СписокДокументов) Тогда
		
		Отказ = Истина;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтаФорма);
		
		ЗаголовокВопроса = "";
		ТекстВопроса = НСтр("ru = 'В списке присутствуют непроведенные, непомеченные на удаление документы. Продолжить?'");
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет,,, ЗаголовокВопроса)
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	УдалитьДокументы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовСтраницыОформлено

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ОписаниеОповещение = Новый ОписаниеОповещения("ОбновитьДанныеСписка", ЭтаФорма);
		ПоказатьЗначение(ОписаниеОповещение, Элемент.ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтотОбъект, Элементы.Список);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.МенюОтчеты

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств(Команда)
	
	УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтаФорма);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

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
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

&НаКлиенте
Процедура КомандаЗакрыть(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументовИзменить(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ПоказатьЗначение(Неопределено, ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументовУстановитьПометкуУдаления(Команда)
	
	ВыделенныеСтрокиСписка = Элементы.Список.ВыделенныеСтроки;
	
	Если ВыделенныеСтрокиСписка.Количество() <> 0 Тогда
		
		ВыделенныеСтроки = Новый Массив;
		
		Для Каждого ТекСтрока Из ВыделенныеСтрокиСписка Цикл
			ВыделенныеСтроки.Добавить(Элементы.Список.ДанныеСтроки(ТекСтрока).Ссылка);
		КонецЦикла;
		
		ЕстьПомеченныеНаУдаление = ЕстьПомеченныеНаУдаление(ВыделенныеСтроки);
		
		Если ВыделенныеСтроки.Количество() = 1 Тогда
			Документ = ВыделенныеСтроки[0];
			ТекстВопроса = ?(ЕстьПомеченныеНаУдаление, НСтр("ru='Снять с ""%1"" пометку на удаление?'"),
			НСтр("ru='Пометить ""%1"" на удаление?'"));
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстВопроса, Документ);
		Иначе
			ТекстВопроса = ?(ЕстьПомеченныеНаУдаление, НСтр("ru='Снять с выделенных элементов пометку на удаление?'"),
			НСтр("ru='Пометить выделенные элементы на удаление?'"));
		КонецЕсли;
		
		СписокОтветов = Новый СписокЗначений;
		СписокОтветов.Добавить(КодВозвратаДиалога.Да, НСтр("ru='Да'"));
		СписокОтветов.Добавить(КодВозвратаДиалога.Нет, НСтр("ru='Нет'"));
		
		ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьПометкуУдаленияЗавершение", 
			ЭтотОбъект, 
			Новый Структура("ВыделенныеСтроки, УстановкаПометкиУдаления", ВыделенныеСтроки, НЕ ЕстьПомеченныеНаУдаление)), 
			ТекстВопроса, 
			СписокОтветов);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументовОтменаПроведения(Команда)
	
	ОчиститьСообщения();
	
	ВыделенныеСтроки = Новый Массив;
		
	Для Каждого ТекСтрока Из Элементы.Список.ВыделенныеСтроки Цикл
		ВыделенныеСтроки.Добавить(Элементы.Список.ДанныеСтроки(ТекСтрока).Ссылка);
	КонецЦикла;
	
	РезультатПроведения = ПроведениеДокументов(ВыделенныеСтроки, Ложь);
	
	ДокументыДляОбработки = РезультатПроведения.ДокументыДляОбработки;
	НеОбработанныеДокументы = РезультатПроведения.НепроведенныеДокументы;
	
	ОповеститьПользователяОПроведенииДокументов(ДокументыДляОбработки, НеОбработанныеДокументы, Ложь);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокДокументовПровести(Команда)
	
	ОчиститьСообщения();
	
	ВыделенныеСтроки = Новый Массив;
	
	Для Каждого ТекСтрока Из Элементы.Список.ВыделенныеСтроки Цикл
		ВыделенныеСтроки.Добавить(Элементы.Список.ДанныеСтроки(ТекСтрока).Ссылка);
	КонецЦикла;
	
	РезультатПроведения = ПроведениеДокументов(ВыделенныеСтроки, Истина);
	
	ДокументыДляОбработки = РезультатПроведения.ДокументыДляОбработки;
	НеОбработанныеДокументы = РезультатПроведения.НепроведенныеДокументы;
	
	ОповеститьПользователяОПроведенииДокументов(ДокументыДляОбработки, НеОбработанныеДокументы, Истина);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СтандартныеПодсистемы

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

#КонецОбласти

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтаФорма, "Список.Дата", "Дата");

КонецПроцедуры

&НаСервере
Процедура ОбновитьОтборы()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Ссылка",
		СписокДокументов,
		ВидСравненияКомпоновкиДанных.ВСписке,
		,
		Истина);
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
			ЭтаФорма.Список,
			"ТекстВидОперацииПроизводство",
			НСтр("ru = 'Производство без заказа'"),
			Истина);
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
			ЭтаФорма.Список,
			"ТекстВидОперацииРаспределение",
			НСтр("ru = 'Распределение возвратных отходов'"),
			Истина);
	
КонецПроцедуры

&НаСервере
Функция ПроведениеДокументов(ВыделенныеСтроки, Проведение = Истина)
	
	// СтандартныеПодсистемы.ЗамерПроизводительности
	ОписаниеЗамера = Производительность.НачатьЗамерВремени(
		"Обработка.ОформлениеПроизводстваБезЗаказов.Форма.ФормаСпискаНовыхДокументов.Команда.СписокДокументовПровести");
	// Конец СтандартныеПодсистемы.ЗамерПроизводительности
	
	СтруктураВозврата = ПровестиДокументы(ВыделенныеСтроки, Проведение);
	
	// СтандартныеПодсистемы.ЗамерПроизводительности
	КоличествоОпераций = СтруктураВозврата.ДокументыДляОбработки.Количество();
	Производительность.ЗакончитьЗамерВремени(ОписаниеЗамера, КоличествоОпераций);
	// Конец СтандартныеПодсистемы.ЗамерПроизводительности
	
	Возврат СтруктураВозврата;
	
КонецФункции

&НаСервере
Функция ПровестиДокументы(ВыделенныеСтроки, Проведение = Истина)
	
	СтруктураВозврата = Новый Структура("ДокументыДляОбработки, НепроведенныеДокументы");
	
	НепроведенныеДокументы = Новый Массив();
	
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		СтруктураВозврата.Вставить("ДокументыДляОбработки", Новый Массив());
		СтруктураВозврата.Вставить("НепроведенныеДокументы", Новый Массив());
		Возврат СтруктураВозврата;
	КонецЕсли;
	
	ДокументыДляОбработки = ОбщегоНазначенияУТВызовСервера.СсылкиДокументовДинамическогоСписка(ВыделенныеСтроки);
	
	Если Проведение Тогда
		НепроведенныеДокументы = ОбщегоНазначения.ПровестиДокументы(ДокументыДляОбработки);
	Иначе
		Для Каждого ТекСтрока Из ВыделенныеСтроки Цикл
			
			НачатьТранзакцию();
			Блокировка = Новый БлокировкаДанных;
			
			Если ТипЗнч(ТекСтрока) = Тип("ДокументСсылка.ПроизводствоБезЗаказа") Тогда
				ЭлементБлокировки = Блокировка.Добавить("Документ.ПроизводствоБезЗаказа");
			ИначеЕсли ТипЗнч(ТекСтрока) = Тип("ДокументСсылка.РаспределениеВозвратныхОтходов") Тогда
				ЭлементБлокировки = Блокировка.Добавить("Документ.РаспределениеВозвратныхОтходов");
			Иначе
				ПредставлениеОшибки = НСтр("ru = 'Документ %1 недоступен для обработки. Обратитесь к администратору.'");
				ПредставлениеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ПредставлениеОшибки, Строка(ТекСтрока));
				НепроведенныеДокументы.Добавить(Новый Структура("Ссылка, ОписаниеОшибки", ТекСтрока, ПредставлениеОшибки));
				Продолжить;
			КонецЕсли;
			ЭлементБлокировки.УстановитьЗначение("Ссылка", ТекСтрока);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			
			Попытка
				Блокировка.Заблокировать();
				ДокументОбъект = ТекСтрока.ПолучитьОбъект();
				ДокументОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
				ЗафиксироватьТранзакцию();
			Исключение
				ПредставлениеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
				НепроведенныеДокументы.Добавить(Новый Структура("Ссылка, ОписаниеОшибки", ТекСтрока, ПредставлениеОшибки));
			КонецПопытки;
			
		КонецЦикла;
	КонецЕсли;
	
	Элементы.Список.Обновить();
	
	СтруктураВозврата.Вставить("ДокументыДляОбработки", ДокументыДляОбработки);
	СтруктураВозврата.Вставить("НепроведенныеДокументы", НепроведенныеДокументы);
	
	Возврат СтруктураВозврата;
	
КонецФункции

&НаСервере
Процедура УдалитьДокументы()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПроизводствоБезЗаказа.Ссылка
		|ИЗ
		|	Документ.ПроизводствоБезЗаказа КАК ПроизводствоБезЗаказа
		|ГДЕ
		|	ПроизводствоБезЗаказа.Ссылка В(&ВыделенныеСтроки)
		|	И ПроизводствоБезЗаказа.ПометкаУдаления
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	РаспределениеВозвратныхОтходов.Ссылка
		|ИЗ
		|	Документ.РаспределениеВозвратныхОтходов КАК РаспределениеВозвратныхОтходов
		|ГДЕ
		|	РаспределениеВозвратныхОтходов.Ссылка В(&ВыделенныеСтроки)
		|	И РаспределениеВозвратныхОтходов.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("ВыделенныеСтроки", СписокДокументов.ВыгрузитьЗначения());
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		Блокировка = Новый БлокировкаДанных;
		
		Если ТипЗнч(Выборка.Ссылка) = Тип("ДокументСсылка.ПроизводствоБезЗаказа") Тогда
			ЭлементБлокировки = Блокировка.Добавить("Документ.ПроизводствоБезЗаказа");
		ИначеЕсли ТипЗнч(Выборка.Ссылка) = Тип("ДокументСсылка.РаспределениеВозвратныхОтходов") Тогда
			ЭлементБлокировки = Блокировка.Добавить("Документ.РаспределениеВозвратныхОтходов");
		Иначе
			ПредставлениеОшибки = НСтр("ru = 'Документ %1 недоступен для обработки. Обратитесь к администратору.'");
			ПредставлениеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ПредставлениеОшибки, Строка(Выборка.Ссылка));
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ПредставлениеОшибки, Выборка.Ссылка);
			Продолжить;
		КонецЕсли;
		ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		
		Попытка
			Блокировка.Заблокировать();
			ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
			ДокументОбъект.Удалить();
			ЗафиксироватьТранзакцию();
		Исключение
			ПредставлениеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ПредставлениеОшибки, Выборка.Ссылка);
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьПользователяОПроведенииДокументов(ДокументыДляОбработки, ДанныеОНеОбработанныхДокументах, Проведение)
	
	НеОбработанныеДокументы = Новый Массив;
	
	ШаблонСообщения = ?(Проведение, 
		НСтр("ru = 'Документ %1 не проведен: %2'"),
		НСтр("ru = 'Документ %1 не удалось сделать непроведенным: %2'"));
	
	Для Каждого ИнформацияОДокументе Из ДанныеОНеОбработанныхДокументах Цикл
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения,
				Строка(ИнформацияОДокументе.Ссылка),
				ИнформацияОДокументе.ОписаниеОшибки),
			ИнформацияОДокументе.Ссылка);
		
		НеОбработанныеДокументы.Добавить(ИнформацияОДокументе.Ссылка);
	КонецЦикла;
	
	Если НеОбработанныеДокументы.Количество() > 0 Тогда
		ТекстДиалога = ?(Проведение, 
				НСтр("ru = 'Не удалось провести один или несколько документов.'"),
				НСтр("ru = 'Не удалось сделать непроведенным один или несколько документов.'"));

		ПоказатьПредупреждение(, ТекстДиалога);
	КонецЕсли;

	ОбработанныеДокументы = ОбщегоНазначенияКлиентСервер.СократитьМассив(ДокументыДляОбработки, НеОбработанныеДокументы);
	
	Если ОбработанныеДокументы.Количество() > 0 Тогда
		
		Если ДокументыДляОбработки.Количество() > 1 Тогда
			Документ = Заголовок;
			ТекстОповещения = НСтр("ru='Изменение (%КоличествоДокументов%)'");
			ТекстОповещения = СтрЗаменить(ТекстОповещения, "%КоличествоДокументов%", ОбработанныеДокументы.Количество());
		Иначе
			Документ = ДокументыДляОбработки[0];
			ТекстОповещения = НСтр("ru='Изменение'");
		КонецЕсли;
		
		ПоказатьОповещениеПользователя(ТекстОповещения, ПолучитьНавигационнуюСсылку(Документ), Строка(Документ),
			БиблиотекаКартинок.Информация32);
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ЕстьПомеченныеНаУдаление(ВыделенныеСтроки)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ПроизводствоБезЗаказа.Ссылка
		|ИЗ
		|	Документ.ПроизводствоБезЗаказа КАК ПроизводствоБезЗаказа
		|ГДЕ
		|	ПроизводствоБезЗаказа.Ссылка В(&ВыделенныеСтроки)
		|	И ПроизводствоБезЗаказа.ПометкаУдаления
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	РаспределениеВозвратныхОтходов.Ссылка
		|ИЗ
		|	Документ.РаспределениеВозвратныхОтходов КАК РаспределениеВозвратныхОтходов
		|ГДЕ
		|	РаспределениеВозвратныхОтходов.Ссылка В(&ВыделенныеСтроки)
		|	И РаспределениеВозвратныхОтходов.ПометкаУдаления";
		
	Запрос.УстановитьПараметр("ВыделенныеСтроки", ВыделенныеСтроки);
	Результат = Запрос.Выполнить();
	
	Возврат Не Результат.Пустой();
	
КонецФункции

&НаКлиенте
Процедура УстановитьПометкуУдаленияЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		МассивСсылок = ДополнительныеПараметры.ВыделенныеСтроки;
		ПометитьНаУдаление = ДополнительныеПараметры.УстановкаПометкиУдаления;
		
		УстановитьПометкуУдаленияЗавершениеСервер(ДополнительныеПараметры);
		
		Если МассивСсылок.Количество() > 1 Тогда
			Документ = Заголовок;
			ТекстОповещения = ?(Не ПометитьНаУдаление, 
				НСтр("ru='Пометка удаления снята (%КоличествоДокументов%)'"),
				НСтр("ru='Пометка удаления установлена (%КоличествоДокументов%)'"));
			ТекстОповещения = СтрЗаменить(ТекстОповещения, "%КоличествоДокументов%", МассивСсылок.Количество());
		Иначе
			Документ = МассивСсылок[0];
			ТекстОповещения = ?(Не ПометитьНаУдаление,
				НСтр("ru='Пометка удаления снята'"),
				НСтр("ru='Пометка удаления установлена'"));
		КонецЕсли;
		
		ПоказатьОповещениеПользователя(ТекстОповещения, ПолучитьНавигационнуюСсылку(Документ), Строка(Документ),
			БиблиотекаКартинок.Информация32);
			
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПометкуУдаленияЗавершениеСервер(ДополнительныеПараметры)
	
	ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
	ПометитьНаУдаление = ДополнительныеПараметры.УстановкаПометкиУдаления;
	
	Для Каждого ТекСтрока Из ВыделенныеСтроки Цикл
		
		НачатьТранзакцию();
		Блокировка = Новый БлокировкаДанных;
			
		Если ТипЗнч(ТекСтрока) = Тип("ДокументСсылка.ПроизводствоБезЗаказа") Тогда
			ЭлементБлокировки = Блокировка.Добавить("Документ.ПроизводствоБезЗаказа");
		ИначеЕсли ТипЗнч(ТекСтрока) = Тип("ДокументСсылка.РаспределениеВозвратныхОтходов") Тогда
			ЭлементБлокировки = Блокировка.Добавить("Документ.РаспределениеВозвратныхОтходов");
		Иначе
			ПредставлениеОшибки = НСтр("ru = 'Документ %1 недоступен для обработки. Обратитесь к администратору.'");
			ПредставлениеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ПредставлениеОшибки, Строка(ТекСтрока));
			Продолжить;
		КонецЕсли;
		ЭлементБлокировки.УстановитьЗначение("Ссылка", ТекСтрока);
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		
		Попытка
			Блокировка.Заблокировать();
			// Запись только тех объектов, значение пометки которых меняется
			Если ПометитьНаУдаление И НЕ ТекСтрока.ПометкаУдаления
				ИЛИ НЕ ПометитьНаУдаление И ТекСтрока.ПометкаУдаления Тогда
				ДокументОбъект = ТекСтрока.ПолучитьОбъект();
				ДокументОбъект.УстановитьПометкуУдаления(ПометитьНаУдаление)
			КонецЕсли;
			ЗафиксироватьТранзакцию();
		Исключение
			ПредставлениеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ПредставлениеОшибки, ТекСтрока);
		КонецПопытки;
	КонецЦикла;
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		ВыполняетсяЗакрытие = Истина;
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ДокументыНеОбработаны(СписокДокументов)
	
	Для Каждого ТекДокумент Из СписокДокументов Цикл
		
		Если Не ТекДокумент.Значение.Проведен И Не ТекДокумент.Значение.ПометкаУдаления Тогда
			Возврат Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьДанныеСписка() Экспорт
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

ВыполняетсяЗакрытие = Ложь;

#КонецОбласти
