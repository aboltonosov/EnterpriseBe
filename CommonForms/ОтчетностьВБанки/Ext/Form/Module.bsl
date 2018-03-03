﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере()
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	НастройкиФильтров = ХранилищеНастроекДанныхФорм.Загрузить("Документ.РегламентированныйОтчет.Форма.ФормаСписка", "НастройкиФильтров");
	НазваниеФормыФильтра = "";
	
	УчетПоВсемОрганизациям = РегламентированнаяОтчетность.ПолучитьПризнакУчетаПоВсемОрганизациям();
	ОсновнаяОрганизация = РегламентированнаяОтчетность.ПолучитьОрганизациюПоУмолчанию();
	
	Если НЕ УчетПоВсемОрганизациям Тогда
		Организация = ОсновнаяОрганизация;
		Элементы.Организация.Доступность = Ложь;
	Иначе

		// Если включен учет по всем организациям
		Организация = ?(НастройкиФильтров = Неопределено, ОсновнаяОрганизация, НастройкиФильтров.Организация);

		Если (НастройкиФильтров = Неопределено) И (Организация <> РегламентированнаяОтчетностьКлиентСервер.ПустоеЗначениеТипа("СправочникСсылка.Организации")) Тогда
					
			РегламентированнаяОтчетность.ИзменитьЭлементОтбораСписка(Список, "Организация", Организация, ЗначениеЗаполнено(Организация));
			СоставФильтраОбособленныеПодразделения();

		КонецЕсли;
		
	КонецЕсли;
	
	Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
		Организация = ОбщегоНазначения.ОбщийМодуль("Справочники.Организации").ОрганизацияПоУмолчанию();
	КонецЕсли;

	ПолеВыбораПериодичность = Перечисления.Периодичность.Квартал;
	
	Если НастройкиФильтров = Неопределено Тогда

		// в случае первого раза, устанавиливаем фильтр по датам
		КонецПериода  = КонецМесяца(ДобавитьМесяц(КонецКвартала(ТекущаяДатаСеанса()), -3));
		НачалоПериода = НачалоКвартала(КонецПериода);
		
		ПоказатьПериод();
		
	Иначе

		НазваниеФормыФильтра = "";

		Если ЗначениеЗаполнено(НастройкиФильтров.ДатаКон) Тогда
			НачалоПериода = НастройкиФильтров.ДатаНач;
			КонецПериода = НастройкиФильтров.ДатаКон;
			ПоказатьПериод();
		Иначе
			НачалоПериода = Дата(1, 1, 1);
			КонецПериода  = Дата(1, 1, 1);
		КонецЕсли;
		
		Если НастройкиФильтров.Свойство("Банк") Тогда
			Банк = НастройкиФильтров.Банк;
		КонецЕсли;
		
		// Если вызвано из справочника, то фильтр установит та форма которая вызвала
		// в этом случае не восстанавливаем свой фильтр
		// Восстановим его только когда форма списка документов будет открыта напрямую

		Если мРежимРаботы <> "ВызваноИзСправочника" Тогда

			ИсточникОтчетаДляОтбора = НастройкиФильтров.ОтчетнаяФормаЗначение;
			НаименованиеОтчетаДляОтбора = НастройкиФильтров.ОтчетнаяФормаПредставление;
			
			ДанныеОтчета = Новый СписокЗначений;
			ДанныеОтчета.Добавить(ИсточникОтчетаДляОтбора, НаименованиеОтчетаДляОтбора);
			
			РеглОтч = ИсточникОтчетаДляОтбора;
		Иначе

			НазваниеФормыФильтра = РеглОтч;

		КонецЕсли;
	КонецЕсли;

	Если мРежимРаботы = Неопределено Тогда
		мРежимРаботы = "";
	КонецЕсли;
	
	ЕстьПравоРедактированияОтчета = ПравоДоступа("Редактирование", Метаданные.Документы.РегламентированныйОтчет);
	
	УстановитьПривилегированныйРежим(Истина);
	ДанныеАутентификации = ИнтернетПоддержкаПользователей.ДанныеАутентификацииПользователяИнтернетПоддержки();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Не ЕстьПравоРедактированияОтчета ИЛИ ОбщегоНазначенияПовтИсп.РазделениеВключено()
		ИЛИ ДанныеАутентификации <> Неопределено Тогда
		Элементы.Предупреждение.Видимость = Ложь;
	КонецЕсли;
	
	УстановитьОтборы(ЭтотОбъект);
	
	Если НЕ ЕстьПравоРедактированияОтчета Тогда
		Элементы.СписокОбновитьСтатусы.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("СтартоватьОбновлениеСтатусовОтчетов", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если Не ЗавершениеРаботы Тогда
		СохранитьНастройки();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если НЕ Очистка Тогда
		УстановитьОтборПоОрганизации();
	Иначе
		Очистка = Ложь;
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОчистка(Элемент, СтандартнаяОбработка)
	
	ОрганизацияОчисткаНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПериодОтчетаОчистка(Элемент, СтандартнаяОбработка)
	
	НачалоПериода = Дата(1, 1, 1);
	КонецПериода  = Дата(1, 1, 1);
	
	УстановитьОтборы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПериодНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	НачалоПериодаВыбор = ?(ЗначениеЗаполнено(НачалоПериода), НачалоПериода, НачалоКвартала(ТекущаяДата()));
	КонецПериодаВыбор  = ?(ЗначениеЗаполнено(КонецПериода), КонецПериода, КонецКвартала(ТекущаяДата()));
	
	ПараметрыВыбора = Новый Структура("НачалоПериода, КонецПериода, ВидПериода", НачалоПериодаВыбор, КонецПериодаВыбор, Неопределено);
	ОписаниеОповещения = Новый ОписаниеОповещения("ОтборВыбратьПериодЗавершение", ЭтаФорма);
	
	ПолноеИмяФормыВыбораПериода = "Обработка.ОбщиеОбъектыРеглОтчетности.Форма.ВыборСтандартногоПериодаГодКвартал";
	
	РегламентированнаяОтчетностьКлиентПереопределяемый.ФормаРегламентированнойОтчетности_ИмяФормыВыбораПериода(ПолноеИмяФормыВыбораПериода);
	
	ОткрытьФорму(ПолноеИмяФормыВыбораПериода, ПараметрыВыбора, , , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура БанкПриИзменении(Элемент)
	
	УстановитьОтборы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура БанкОчистка(Элемент, СтандартнаяОбработка)
	
	УстановитьОтборы(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьСтатусы(Команда)
	
	ОчиститьСообщения();
	
	ОбновитьСтатусыОтчетов(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьИнтернетПоддержку(Команда)
	
	Обработчик = Новый ОписаниеОповещения("ПослеПодключенияИнтернетПоддержкиПользователей", ЭтотОбъект);
	ИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(Обработчик, ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
	ОткрытьФормуНовогоОтчета(Копирование);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОтборПоОрганизации()
	
	Перем ОтборОрганизация;
	
	ОтборДинамическогоСписка = Список.КомпоновщикНастроек.Настройки.Отбор;
		
	Для Каждого Элемент Из ОтборДинамическогоСписка.Элементы Цикл
		
		Если Элемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Организация") Тогда
			ОтборОрганизация = Элемент;
		КонецЕсли;
				
	КонецЦикла;
	
	Если ОтборОрганизация = Неопределено Тогда
		ОтборОрганизация = ОтборДинамическогоСписка.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборОрганизация.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Организация");
	КонецЕсли;
				
	ОтборОрганизация.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборОрганизация.ПравоеЗначение = Организация;
		
	ОтборОрганизация.Использование = Истина;
	
	ОтборДинамическогоСписка.ИдентификаторПользовательскойНастройки = Строка(Новый УникальныйИдентификатор);
			
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройки()
	
	НастройкиФильтров = Новый Структура;
	
	НастройкиФильтров.Вставить("ДатаНач", НачалоПериода);
	НастройкиФильтров.Вставить("ДатаКон", КонецПериода);
	
	НастройкиФильтров.Вставить("Организация", Организация);
	НастройкиФильтров.Вставить("Банк", Банк);
	
	НастройкиФильтров.Вставить("ОтчетнаяФормаПредставление", НазваниеФормыФильтра);
	
	НастройкиФильтров.Вставить("ОтчетнаяФормаЗначение", РеглОтч);
			
	НастройкиФильтров.Вставить("Периодичность", ПолеВыбораПериодичность);

	ХранилищеНастроекДанныхФорм.Сохранить("Документ.РегламентированныйОтчет.Форма.ФормаСписка", "НастройкиФильтров", НастройкиФильтров);
		
КонецПроцедуры

&НаСервере
Процедура СоставФильтраОбособленныеПодразделения()

	РегламентированнаяОтчетность.ИзменитьЭлементОтбораСписка(Список, "Организация", Организация, ЗначениеЗаполнено(Организация));

КонецПроцедуры

&НаСервере
Процедура ПоказатьПериод()

	ПериодОтчета = ПредставлениеПериода( НачалоДня(НачалоПериода), КонецДня(КонецПериода), "ФП = Истина" );

КонецПроцедуры

&НаСервереБезКонтекста
Функция ИмяФормыОбъектаПоУмолчанию(Ссылка)
	
	Возврат Ссылка.Метаданные().ПолноеИмя() + ".ФормаОбъекта";
	
КонецФункции

&НаСервере
Процедура ОрганизацияОчисткаНаСервере()
	
	Перем ОтборОрганизация;
	
	ОтборДинамическогоСписка = Список.КомпоновщикНастроек.Настройки.Отбор;
						
	Для Каждого Элемент Из ОтборДинамическогоСписка.Элементы Цикл
		
		Если Элемент.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Организация") Тогда
			ОтборОрганизация = Элемент;
		КонецЕсли;
				
	КонецЦикла;
	
	Если НЕ ОтборОрганизация = Неопределено Тогда
		ОтборДинамическогоСписка.Элементы.Удалить(ОтборОрганизация);
	КонецЕсли;
	
	ОтборДинамическогоСписка.ИдентификаторПользовательскойНастройки = Строка(Новый УникальныйИдентификатор);
			
	Очистка = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуНовогоОтчета(Копирование)
	
	Если НЕ Копирование Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Организация", Организация);
		ПараметрыФормы.Вставить("Банк", Банк);
		Если ЗначениеЗаполнено(ПериодОтчета) Тогда
			ПараметрыФормы.Вставить("мДатаКонцаПериодаОтчета", КонецПериода);
			ПараметрыФормы.Вставить("мДатаНачалаПериодаОтчета", НачалоПериода);
		КонецЕсли;
		
		ОткрытьФорму("Отчет.БухгалтерскаяОтчетностьВБанк.Форма.ОсновнаяФорма", ПараметрыФормы, ЭтотОбъект, ,
			, , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	Иначе
		
		ТекущиеДанные = Элементы.Список.ТекущиеДанные;
		
		Если ТекущиеДанные <> Неопределено Тогда
			
			Ссылка = ТекущиеДанные.Ссылка;
			ПараметрыФормы = Новый Структура("ЗначениеКопирования", Ссылка); 
			
			Если ТипЗнч(Ссылка) = Тип("СправочникСсылка.ЭлектронныеПредставленияРегламентированныхОтчетов") Тогда
				
				ОткрытьФорму("Справочник.ЭлектронныеПредставленияРегламентированныхОтчетов.ФормаОбъекта", ПараметрыФормы);
				
			ИначеЕсли ТипЗнч(Ссылка) = Тип("ДокументСсылка.РегламентированныйОтчет") Тогда
				
				ОткрытьФорму("Документ.РегламентированныйОтчет.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
				
			Иначе
				
				ИмяФормыОбъекта = ИмяФормыОбъектаПоУмолчанию(Ссылка);
				ОткрытьФорму(ИмяФормыОбъекта, ПараметрыФормы);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если ТипЗнч(РезультатВыбора) <> Тип("Структура")
		 ИЛИ НЕ РезультатВыбора.Свойство("НачалоПериода")
		 ИЛИ НЕ РезультатВыбора.Свойство("КонецПериода") Тогда
		
		Возврат;
		
	КонецЕсли;
	
	НачалоПериода = ?(ЗначениеЗаполнено(РезультатВыбора.НачалоПериода), НачалоДня(РезультатВыбора.НачалоПериода), РезультатВыбора.НачалоПериода);
	КонецПериода  = ?(ЗначениеЗаполнено(РезультатВыбора.КонецПериода),  КонецДня(РезультатВыбора.КонецПериода),   РезультатВыбора.КонецПериода);
	
	ПоказатьПериод();
	
	УстановитьОтборы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборы(Форма)
	
	ОтборДинамическогоСписка = Форма.Список.КомпоновщикНастроек.Настройки.Отбор;
	
	ОтборДинамическогоСписка.Элементы.Очистить();
	
	ОтборОрганизация = ОтборДинамическогоСписка.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборДатаНачала = ОтборДинамическогоСписка.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборДатаОкончания1 = ОтборДинамическогоСписка.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборДатаОкончания2 = ОтборДинамическогоСписка.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЗаполненБанк = ОтборДинамическогоСписка.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборБанк = ОтборДинамическогоСписка.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	
	ОтборОрганизация.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Организация");
	ОтборДатаНачала.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДатаНачала");
	ОтборДатаОкончания1.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДатаОкончания");
	ОтборДатаОкончания2.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДатаОкончания");
	ОтборЗаполненБанк.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Банк");
	ОтборБанк.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Банк");
	
	ОтборЗаполненБанк.Использование = Истина;
	ОтборЗаполненБанк.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	
	Если НЕ ЗначениеЗаполнено(Форма.Организация) Тогда
		ОтборОрганизация.Использование = Ложь;
	Иначе
		ОтборОрганизация.Использование  = Истина;
		ОтборОрганизация.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		ОтборОрганизация.ПравоеЗначение = Форма.Организация;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Форма.Банк) Тогда
		ОтборБанк.Использование = Ложь;
	Иначе
		ОтборБанк.Использование = Истина;
		ОтборБанк.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборБанк.ПравоеЗначение = Форма.Банк;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Форма.ПериодОтчета) Тогда
		ОтборДатаНачала.Использование = Ложь;
		ОтборДатаОкончания1.Использование = Ложь;
		ОтборДатаОкончания2.Использование = Ложь;
	Иначе
		Если ЗначениеЗаполнено(Форма.НачалоПериода) Тогда
			ОтборДатаНачала.Использование      = Истина;
			ОтборДатаНачала.ВидСравнения       = ВидСравненияКомпоновкиДанных.БольшеИлиРавно;
			ОтборДатаНачала.ПравоеЗначение     = НачалоГода(Форма.НачалоПериода);
			
			ОтборДатаОкончания1.Использование  = Истина;
			ОтборДатаОкончания1.ВидСравнения   = ВидСравненияКомпоновкиДанных.Больше;
			ОтборДатаОкончания1.ПравоеЗначение = Форма.НачалоПериода;
		Иначе
			ОтборДатаНачала.Использование      = Ложь;
			ОтборДатаОкончания1.Использование  = Ложь;
		КонецЕсли;
		Если ЗначениеЗаполнено(Форма.КонецПериода) Тогда
			ОтборДатаОкончания2.Использование  = Истина;
			ОтборДатаОкончания2.ВидСравнения   = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно;
			ОтборДатаОкончания2.ПравоеЗначение = Форма.КонецПериода;
		Иначе
			ОтборДатаОкончания2.Использование  = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	ОтборДинамическогоСписка.ИдентификаторПользовательскойНастройки = Строка(Новый УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПодключенияИнтернетПоддержкиПользователей(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.Предупреждение.Видимость = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеОбновленияСтатусовОтчетов(Результат, ДополнительныеПараметры) Экспорт
	
	Элементы.Список.Обновить();
	Если ДополнительныеПараметры.ВыводитьОшибку Тогда
		Если Результат.Статус = "Ошибка" Тогда
			ВидОперации = НСтр("ru = 'Обновление статусов отчетов.'");
			ОтчетностьВБанкиСлужебныйВызовСервера.ОбработатьОшибку(
				ВидОперации, Результат.ПодробноеПредставлениеОшибки, Результат.КраткоеПредставлениеОшибки, 1);
		КонецЕсли;
	Иначе
		ПодключитьОбработчикОжидания("СтартоватьОбновлениеСтатусовОтчетов", 300, Истина);
	КонецЕсли;
	
	МассивОтчетов = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
	Если МассивОтчетов.Количество() Тогда
		Оповестить("ПолученСтатусОтчетаВБанке", МассивОтчетов);
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеПоОбновлениюСтатусовНаСервере(Знач ИдентификаторФормы, Знач ПараметрыКлиента)
	
	ПараметрыПроцедуры = Новый Структура("ПараметрыКлиента", ПараметрыКлиента);
	
	ПараметрыВыполненияВФоне = ДлительныеОперации.ПараметрыВыполненияВФоне(ИдентификаторФормы);
	ПараметрыВыполненияВФоне.НаименованиеФоновогоЗадания = Нстр("ru = 'Получение статусов отчетов для банков.'");
	ПараметрыВыполненияВФоне.ЗапуститьВФоне = Истина;
	Возврат ДлительныеОперации.ВыполнитьВФоне(
		"ОтчетностьВБанкиСлужебный.ОбновитьСтатусыОтчетов", ПараметрыПроцедуры, ПараметрыВыполненияВФоне);
	
КонецФункции

&НаКлиенте
Процедура СтартоватьОбновлениеСтатусовОтчетов()
	
	ОбновитьСтатусыОтчетов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеФоновогоОбновленияСтатусовОтчетов(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено И Результат.Статус = "Выполнено" Тогда
		МассивОтчетов = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);
		Если МассивОтчетов.Количество() Тогда
			Оповестить("ПолученСтатусОтчетаВБанке", МассивОтчетов);
			Элементы.Список.Обновить();
		КонецЕсли;
	КонецЕсли;
	
	Если ДополнительныеПараметры.ВыводитьОшибку Тогда
		Если Результат.Статус = "Ошибка" Тогда
			ВидОперации = НСтр("ru = 'Обновление статусов отчетов.'");
			ОтчетностьВБанкиСлужебныйВызовСервера.ОбработатьОшибку(
				ВидОперации, Результат.ПодробноеПредставлениеОшибки, Результат.КраткоеПредставлениеОшибки, 1);
		КонецЕсли;
	Иначе
		ПодключитьОбработчикОжидания("СтартоватьОбновлениеСтатусовОтчетов", 300, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСтатусыОтчетов(ВыводитьОшибку = Ложь)
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(Неопределено);
	ПараметрыОжидания.ТекстСообщения = НСтр("ru = 'Получение статусов отчетов для банков'");
	ПараметрыОжидания.ВыводитьОкноОжидания = ВыводитьОшибку;
	ДополнительныеПараметры = Новый Структура("ВыводитьОшибку", ВыводитьОшибку);
	Оповещение = Новый ОписаниеОповещения("ПослеФоновогоОбновленияСтатусовОтчетов", ЭтотОбъект, ДополнительныеПараметры);
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	ПараметрыКлиента = Новый Структура;
	ПараметрыКлиента.Вставить("ТипПлатформы", Строка(СистемнаяИнформация.ТипПлатформы));
	ПараметрыКлиента.Вставить("ВерсияОС", СистемнаяИнформация.ВерсияОС);

	ДлительнаяОперация = ЗаданиеПоОбновлениюСтатусовНаСервере(УникальныйИдентификатор, ПараметрыКлиента);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, Оповещение, ПараметрыОжидания);
	
КонецПроцедуры


#КонецОбласти