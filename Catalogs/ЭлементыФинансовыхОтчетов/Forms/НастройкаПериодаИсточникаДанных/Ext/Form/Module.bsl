﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = БюджетнаяОтчетностьКлиентСервер.ПараметрыОткрытияФормыНастройкиПериода(Параметры);
	ЗаполнитьЗначенияСвойств(ЭтаФорма, ПараметрыФормы);
	
	Если Не Параметры.Свойство("НефинансовыйПоказатель") Тогда
	
		УстановитьВидимостьНастройкиГруппировки(Параметры);
		
		СписокВыбора = Элементы.ГраницыДанных.СписокВыбора;
		Если Параметры.ВариантРасположенияГраницыФактическихДанных = Перечисления.ВариантыРасположенияГраницыФактическиДанных.ДоНачалаСоставленияБюджета Тогда
			СписокВыбора.Удалить(СписокВыбора.НайтиПоЗначению("НачалоФакт"));
		ИначеЕсли Параметры.ВариантРасположенияГраницыФактическихДанных = Перечисления.ВариантыРасположенияГраницыФактическиДанных.ВнутриПериодаБюджета Тогда
			СписокВыбора.Удалить(СписокВыбора.НайтиПоЗначению("ФактНачало"));
		КонецЕсли;
		
	Иначе
		
		Элементы.ГруппаДеталиГраницДанных.Видимость = Ложь;
		Элементы.ГраницыДанных.Видимость = Ложь;
		Элементы.ПериодЗначения.Видимость = Ложь;
		
	КонецЕсли;
	
	УстановитьВариантыПериодов();
	УправлениеФормой();
	
	ВариантОкна = "БезГруппировки";
	Если Не Элементы.ГраницыДанных.Видимость Тогда
		ВариантОкна = "НефинансовыйПоказатель";
	ИначеЕсли Элементы.ПериодЗначения.Видимость Тогда
		ВариантОкна = "ГруппировкаПериод";
	КонецЕсли;
	
	ЭтаФорма.КлючСохраненияПоложенияОкна = "ВариантФормы_" + ВариантОкна;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	Перем Ошибки;
	
	НепроверяемыеРеквизиты = Новый Массив;
	ЕстьОшибкаВНачале = Ложь; ЕстьОшибкаВКонце = Ложь;
	
	Если Элементы.ГраницыДанных.Видимость Тогда
		УпорядоченныеПериодичности = Новый Массив;
		УпорядоченныеПериодичности.Добавить("СЕКУНДА");
		УпорядоченныеПериодичности.Добавить("МИНУТА");
		УпорядоченныеПериодичности.Добавить("ЧАС");
		Для Каждого Периодичность из УпорядоченныеПериодичности Цикл
			Если Не ЕстьОшибкаВНачале И СтрНайти(ВРЕГ(НижняяГраницаДанных), ВРЕГ(Строка(Периодичность))) Тогда
				ТекстОшибки = НСтр("ru = 'Выражение границ начала периода не может содержать периодичность меньшую, чем день'");
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "НижняяГраницаДанных", ТекстОшибки, "");
				ЕстьОшибкаВНачале = Истина;
			КонецЕсли;
			Если Не ЕстьОшибкаВКонце И СтрНайти(ВРЕГ(ВерхняяГраницаДанных), ВРЕГ(Строка(Периодичность))) Тогда
				ТекстОшибки = НСтр("ru = 'Выражение границ конца периода не может содержать периодичность меньшую, чем день'");
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "ВерхняяГраницаДанных", ТекстОшибки, "");
				ЕстьОшибкаВКонце = Истина;
			КонецЕсли;
			Если ЕстьОшибкаВНачале И ЕстьОшибкаВКонце Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
	Иначе
		НепроверяемыеРеквизиты.Добавить("НижняяГраницаДанных");
		НепроверяемыеРеквизиты.Добавить("ВерхняяГраницаДанных");
	КонецЕсли;
	
	ЕстьОшибкаВНачале = Ложь; ЕстьОшибкаВКонце = Ложь;
	
	Если ЗначениеЗаполнено(ПериодичностьГруппировки)
		И Элементы.ПериодЗначения.Видимость Тогда
		УпорядоченныеПериодичности = Перечисления.Периодичность.УпорядоченныеПериодичности();
		УпорядоченныеПериодичности.Вставить(0, "СЕКУНДА");
		УпорядоченныеПериодичности.Вставить(0, "МИНУТА");
		УпорядоченныеПериодичности.Вставить(0, "ЧАС");
		Для Каждого Периодичность из УпорядоченныеПериодичности Цикл
			Если Не ЗначениеЗаполнено(Периодичность) Тогда
				Продолжить;
			КонецЕсли;
			Если Периодичность = ПериодичностьГруппировки Тогда
				Прервать;
			КонецЕсли;
			Если Не ЕстьОшибкаВНачале И СтрНайти(ВРЕГ(НачалоПериодаГруппировки), ВРЕГ(Строка(Периодичность))) Тогда
				ТекстОшибки = НСтр("ru = 'Выражение смещения начала периода группировки не может содержать периодичность меньшую, чем %1'");
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ПериодичностьГруппировки);
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "НачалоПериодаГруппировки", ТекстОшибки, "");
				ЕстьОшибкаВНачале = Истина;
			КонецЕсли;
			Если Не ЕстьОшибкаВКонце И СтрНайти(ВРЕГ(КонецПериодаГруппировки), ВРЕГ(Строка(Периодичность))) Тогда
				ТекстОшибки = НСтр("ru = 'Выражение смещения конца периода группировки не может содержать периодичность меньшую, чем %1'");
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ПериодичностьГруппировки);
				ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "КонецПериодаГруппировки", ТекстОшибки, "");
				ЕстьОшибкаВКонце = Истина;
			КонецЕсли;
			Если ЕстьОшибкаВНачале И ЕстьОшибкаВКонце Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если Не Элементы.ПериодЗначения.Видимость Тогда
		НепроверяемыеРеквизиты.Добавить("НачалоПериодаГруппировки");
		НепроверяемыеРеквизиты.Добавить("КонецПериодаГруппировки");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		ЗначенияЗакрытия = БюджетнаяОтчетностьКлиентСервер.ПараметрыОткрытияФормыНастройкиПериода(ЭтаФорма, Ложь);
		Закрыть(ЗначенияЗакрытия);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГраницыДанныхПриИзменении(Элемент)
	
	Если ГраницыДанных = "" Тогда
		
		НижняяГраницаДанных = "[Начало периода данных]";
		ВерхняяГраницаДанных = "[Конец периода данных]";
		
	ИначеЕсли ГраницыДанных = "ФактНачало" Тогда
		
		НижняяГраницаДанных = "[Граница факт.данных]";
		ВерхняяГраницаДанных = "ДобавитьКДате([Начало периода данных], ДЕНЬ, -1)";
		
	ИначеЕсли ГраницыДанных = "НачалоФакт" Тогда
		
		НижняяГраницаДанных = "[Начало периода данных]";
		ВерхняяГраницаДанных = "[Граница факт.данных]";
		
	ИначеЕсли ГраницыДанных = "ФактКонец" Тогда
		
		НижняяГраницаДанных = "ДобавитьКДате([Граница факт.данных], ДЕНЬ, 1)";
		ВерхняяГраницаДанных = "[Конец периода данных]";
		
	ИначеЕсли ГраницыДанных = "Произвольный" Тогда
		
		НижняяГраницаДанных = "[Начало периода данных]";
		ВерхняяГраницаДанных = "[Конец периода данных]";
		
	КонецЕсли;
	
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантПериодаОтносительноГруппировкиПриИзменении(Элемент)
	
	Если ВариантПериодаОтносительноГруппировки = "" Тогда
		
		НачалоПериодаГруппировки = "[Период группировки]";
		КонецПериодаГруппировки = "[Период группировки]";
		
	ИначеЕсли ВариантПериодаОтносительноГруппировки = "НарастающийИтог" Тогда
		
		НачалоПериодаГруппировки = "[Начало периода данных]";
		КонецПериодаГруппировки = "[Период группировки]";
		
	ИначеЕсли ВариантПериодаОтносительноГруппировки = "ВесьПериод" Тогда
		
		НачалоПериодаГруппировки = "[Начало периода данных]";
		КонецПериодаГруппировки = "[Конец периода данных]";
		
	ИначеЕсли ВариантПериодаОтносительноГруппировки = "Произвольный" Тогда
		
		НачалоПериодаГруппировки = "[Период группировки]";
		КонецПериодаГруппировки = "[Период группировки]";
		
	КонецЕсли;
	
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура НижняяГраницаПериодаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОписаниеОповещения = Новый ОписаниеОповещения("ИзменениеФормулы", ЭтаФорма, "НижняяГраницаДанных");
	ОткрытьФорму("ОбщаяФорма.КонструкторФормул", 
		ПолучитьПараметрыФормыПериодаДанных(НижняяГраницаДанных),,,,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ВерхняяГраницаПериодаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОписаниеОповещения = Новый ОписаниеОповещения("ИзменениеФормулы", ЭтаФорма, "ВерхняяГраницаДанных");
	ОткрытьФорму("ОбщаяФорма.КонструкторФормул", 
		ПолучитьПараметрыФормыПериодаДанных(ВерхняяГраницаДанных),,,,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстНачалаГруппировкиНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОписаниеОповещения = Новый ОписаниеОповещения("ИзменениеФормулы", ЭтаФорма, "НачалоПериодаГруппировки");
	ОткрытьФорму("ОбщаяФорма.КонструкторФормул", 
		ПолучитьПараметрыФормыПериодаГруппировки(НачалоПериодаГруппировки),,,,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстОкончанияГруппировкиНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОписаниеОповещения = Новый ОписаниеОповещения("ИзменениеФормулы", ЭтаФорма, "КонецПериодаГруппировки");
	ОткрытьФорму("ОбщаяФорма.КонструкторФормул", 
		ПолучитьПараметрыФормыПериодаГруппировки(КонецПериодаГруппировки),,,,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВидимостьНастройкиГруппировки(Параметры)
	
	ЕстьПериод = Справочники.ЭлементыФинансовыхОтчетов.ЭлементРазвернутПоПериоду(Параметры, ПериодичностьГруппировки);
	Элементы.ПериодЗначения.Видимость = ЕстьПериод;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВариантыПериодов()
	
	Если НижняяГраницаДанных = "[Начало периода данных]"
		И ВерхняяГраницаДанных = "[Конец периода данных]" Тогда
		
		ГраницыДанных = "";
		
	ИначеЕсли НижняяГраницаДанных = "[Граница факт.данных]"
		И ВерхняяГраницаДанных = "ДобавитьКДате([Начало периода данных], ДЕНЬ, -1)" Тогда
		
		ГраницыДанных = "ФактНачало";
		
	ИначеЕсли НижняяГраницаДанных = "[Начало периода данных]"
		И ВерхняяГраницаДанных = "[Граница факт.данных]" Тогда
		
		ГраницыДанных = "НачалоФакт";
		
	ИначеЕсли НижняяГраницаДанных = "ДобавитьКДате([Граница факт.данных], ДЕНЬ, 1)"
		И ВерхняяГраницаДанных = "[Конец периода данных]" Тогда
	
		ГраницыДанных = "ФактКонец";
		
	Иначе
		
		ГраницыДанных = "Произвольный";
		
	КонецЕсли;
	
	Если НачалоПериодаГруппировки = "[Период группировки]" 
		И КонецПериодаГруппировки = "[Период группировки]" Тогда
		
		ВариантПериодаОтносительноГруппировки = "";
		
	ИначеЕсли НачалоПериодаГруппировки = "[Начало периода данных]" 
		И КонецПериодаГруппировки = "[Период группировки]" Тогда
		
		ВариантПериодаОтносительноГруппировки = "НарастающийИтог";
		
	ИначеЕсли НачалоПериодаГруппировки = "[Начало периода данных]" 
		И КонецПериодаГруппировки = "[Конец периода данных]" Тогда
		
		ВариантПериодаОтносительноГруппировки = "ВесьПериод";
		
	Иначе
		
		ВариантПериодаОтносительноГруппировки = "Произвольный";
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФормой()
	
	ПроизвольныйПериодДанных = ГраницыДанных = "Произвольный";
	
	Элементы.НижняяГраницаДанных.Доступность = ПроизвольныйПериодДанных;
	Элементы.ВерхняяГраницаДанных.Доступность = ПроизвольныйПериодДанных;
	
	ПроизвольныйПериодГруппировки = ВариантПериодаОтносительноГруппировки = "Произвольный";
	
	Элементы.НачалоПериодаГруппировки.Доступность = ПроизвольныйПериодГруппировки;
	Элементы.КонецПериодаГруппировки.Доступность = ПроизвольныйПериодГруппировки;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменениеФормулы(Результат, ИмяПоля) Экспорт
	
	Если Результат <> Неопределено Тогда
		ЭтаФорма[ИмяПоля] = Результат;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПостроитьДеревоОператоров()
	
	ДеревоОператоров = ФинансоваяОтчетностьВызовСервера.ПостроитьДеревоОператоров();
	СтрокаФункции = ДеревоОператоров.Строки.Найти("Функции");
	
	РаботаСФормулами.ДобавитьОператор(ДеревоОператоров, СтрокаФункции, НСтр("ru = 'Добавить месяц'"), 		НСтр("ru = 'ДобавитьКДате( , МЕСЯЦ, 1)'"));
	РаботаСФормулами.ДобавитьОператор(ДеревоОператоров, СтрокаФункции, НСтр("ru = 'Добавить год'"), 		НСтр("ru = 'ДобавитьКДате( , ГОД, 1)'"));
	
	РаботаСФормулами.ДобавитьОператор(ДеревоОператоров, СтрокаФункции, НСтр("ru = 'Начало года'"), 			НСтр("ru = 'НачалоПериода( , ГОД)'"));
	РаботаСФормулами.ДобавитьОператор(ДеревоОператоров, СтрокаФункции, НСтр("ru = 'Начало полугодия'"), 	НСтр("ru = 'НачалоПериода( , ПОЛУГОДИЕ)'"));
	РаботаСФормулами.ДобавитьОператор(ДеревоОператоров, СтрокаФункции, НСтр("ru = 'Начало квартала'"), 		НСтр("ru = 'НачалоПериода( , КВАРТАЛ)'"));
	РаботаСФормулами.ДобавитьОператор(ДеревоОператоров, СтрокаФункции, НСтр("ru = 'Начало месяца'"), 		НСтр("ru = 'НачалоПериода( , МЕСЯЦ)'"));
	РаботаСФормулами.ДобавитьОператор(ДеревоОператоров, СтрокаФункции, НСтр("ru = 'Начало недели'"), 		НСтр("ru = 'НачалоПериода( , НЕДЕЛЯ)'"));
	
	РаботаСФормулами.ДобавитьОператор(ДеревоОператоров, СтрокаФункции, НСтр("ru = 'Конец года'"), 			НСтр("ru = 'КонецПериода( , ГОД)'"));
	РаботаСФормулами.ДобавитьОператор(ДеревоОператоров, СтрокаФункции, НСтр("ru = 'Конец полугодия'"), 		НСтр("ru = 'КонецПериода( , ПОЛУГОДИЕ)'"));
	РаботаСФормулами.ДобавитьОператор(ДеревоОператоров, СтрокаФункции, НСтр("ru = 'Конец квартала'"), 		НСтр("ru = 'КонецПериода( , КВАРТАЛ)'"));
	РаботаСФормулами.ДобавитьОператор(ДеревоОператоров, СтрокаФункции, НСтр("ru = 'Конец месяца'"), 		НСтр("ru = 'КонецПериода( , МЕСЯЦ)'"));
	РаботаСФормулами.ДобавитьОператор(ДеревоОператоров, СтрокаФункции, НСтр("ru = 'Конец недели'"), 		НСтр("ru = 'КонецПериода( , НЕДЕЛЯ)'"));
	
	Возврат ПоместитьВоВременноеХранилище(ДеревоОператоров);
	
КонецФункции

&НаСервере
Функция ПолучитьПараметрыФормыПериодаДанных(Формула)
	
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Идентификатор");
	
	НоваяСтрока = Таблица.Добавить();
	НоваяСтрока.Идентификатор = "Начало периода данных";
	
	НоваяСтрока = Таблица.Добавить();
	НоваяСтрока.Идентификатор = "Конец периода данных";
	
	НоваяСтрока = Таблица.Добавить();
	НоваяСтрока.Идентификатор = "Граница факт.данных";
	
	АдресДат = ПоместитьВоВременноеХранилище(Таблица);
	
	Возврат Новый Структура("Формула, Операнды, ОперандыЗаголовок, 
							|Операторы, ФормулаДляВычисленияВЗапросе, ТипРезультата, НеИспользоватьПредставление", 
							Формула, АдресДат, НСтр("ru = 'Даты для расчета'"), 
							ПостроитьДеревоОператоров(), Истина, Новый ОписаниеТипов("Дата"), Истина);
	
КонецФункции

&НаСервере
Функция ПолучитьПараметрыФормыПериодаГруппировки(Формула)
	
	
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Идентификатор");
	
	НоваяСтрока = Таблица.Добавить();
	НоваяСтрока.Идентификатор = "Начало периода данных";
	
	НоваяСтрока = Таблица.Добавить();
	НоваяСтрока.Идентификатор = "Конец периода данных";
	
	НоваяСтрока = Таблица.Добавить();
	НоваяСтрока.Идентификатор = "Период группировки";
	
	НоваяСтрока = Таблица.Добавить();
	НоваяСтрока.Идентификатор = "Граница факт.данных";
	
	АдресДат = ПоместитьВоВременноеХранилище(Таблица);
	
	Возврат Новый Структура("Формула, Операнды, ОперандыЗаголовок, 
							|Операторы, ФормулаДляВычисленияВЗапросе, ТипРезультата, НеИспользоватьПредставление", 
							Формула, АдресДат, НСтр("ru = 'Даты для расчета'"), 
							ПостроитьДеревоОператоров(), Истина, Новый ОписаниеТипов("Дата"), Истина);
	
КонецФункции

#КонецОбласти