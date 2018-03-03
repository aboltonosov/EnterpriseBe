﻿
&НаКлиенте
Перем КэшированныеЗначения; // используется механизмом обработки изменения реквизитов ТЧ

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
	КонецЕсли;
	
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	// ВводНаОсновании
	ВводНаОсновании.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюСоздатьНаОсновании);
	// Конец ВводНаОсновании
	
	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПодготовитьФормуНаСервере();
	
	СобытияФорм.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Справочник.ОбъектыЭксплуатации.Форма.ФормаВыбора" Тогда
		
		Если ВыбранноеЗначение.Количество() > 0 Тогда
			Для Каждого ЭлементМассива Из ВыбранноеЗначение Цикл
				Объект.ОС.Добавить().ОсновноеСредство = ЭлементМассива;
			КонецЦикла;
			ЗаполнитьИнвентарныеНомера();
		КонецЕсли;
		
	ИначеЕсли ИсточникВыбора.ИмяФормы = "ОбщаяФорма.РеквизитыПечатиРеализации" Тогда
		
		Если ВыбранноеЗначение <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(Объект, ВыбранноеЗначение);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	СобытияФормКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если Объект.ОС.Количество() > 0 Тогда
		ЗаполнитьИнвентарныеНомера();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	Если Объект.ОС.Количество() > 0 Тогда
		ЗаполнитьИнвентарныеНомера();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЦенаВключаетНДСПриИзменении(Элемент)
	ЦенаВключаетНДСПриИзмененииСервер(КэшированныеЗначения);
КонецПроцедуры

&НаКлиенте
Процедура ВалютаПриИзменении(Элемент)
	ПересчитатьСуммыПоВалюте();
КонецПроцедуры

&НаКлиенте
Процедура НалогообложениеНДСПриИзменении(Элемент)
	НалогообложениеНДСПриИзмененииСервер();
КонецПроцедуры

&НаКлиенте
Процедура ПередачаВыполненаПриИзменении(Элемент)
	
	Объект.ДатаПередачи = ОбщегоНазначенияКлиент.ДатаСеанса();
	
КонецПроцедуры

&НаКлиенте
Процедура ПартнерПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(Объект.Партнер) Тогда
		Возврат;
	КонецЕсли; 
	
	ПартнерПриИзмененииНаСервере()
	
КонецПроцедуры

&НаСервере
Процедура ПартнерПриИзмененииНаСервере()
	
	ПартнерыИКонтрагенты.ЗаполнитьКонтрагентаПартнераПоУмолчанию(Объект.Партнер, Объект.Контрагент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийТаблицы

&НаКлиенте
Процедура ОСОсновноеСредствоПриИзменении(Элемент)
	
	СтрокаТЧ = Элементы.ОС.ТекущиеДанные;
	ОсновноеСредство = СтрокаТЧ.ОсновноеСредство;
	Если НЕ ЗначениеЗаполнено(ОсновноеСредство) Тогда
		СтрокаТЧ.ИнвентарныйНомер = "";
	Иначе
		СтрокаТЧ.ИнвентарныйНомер = УчетОСВызовСервера.ПолучитьИнвентарныйНомерОС(ОсновноеСредство, Объект.Организация, Объект.Дата);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОССуммаПриИзменении(Элемент)
	
	Действия = Новый Структура;
	ДобавитьДействияПересчетаНДС(Действия, Объект);
	Действия.Вставить("ПересчитатьЦенуСкидкуПоСуммеВПродажах", Новый Структура("ИмяКоличества", "Количество"));
	
	СтрокаТЧ = СоздатьСтрокуПересчетаСумм(Элементы.ОС.ТекущиеДанные);
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(СтрокаТЧ, Действия, КэшированныеЗначения);
	ЗаполнитьЗначенияСвойств(Элементы.ОС.ТекущиеДанные, СтрокаТЧ);
	
КонецПроцедуры

&НаКлиенте
Процедура ОССтавкаНДСПриИзменении(Элемент)
	
	Действия = Новый Структура;
	ДобавитьДействияПересчетаСумм(Действия, Объект);
	
	СтрокаТЧ = СоздатьСтрокуПересчетаСумм(Элементы.ОС.ТекущиеДанные);
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(СтрокаТЧ, Действия, КэшированныеЗначения);
	ЗаполнитьЗначенияСвойств(Элементы.ОС.ТекущиеДанные, СтрокаТЧ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// ВводНаОсновании
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(
		Истина, "Документ.ПодготовкаКПередачеОС.ФормаДокумента.Подключаемый_ВыполнитьКомандуСоздатьНаОсновании");
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец ВводНаОсновании

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец МенюОтчеты

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоНаименованию(Команда)
	
	ОсновноеСредство = УправлениеВнеоборотнымиАктивамиКлиент.ПолучитьОСДляЗаполнениеПоНаименованию(
		ПараметрыЗаполненияПоНаименованию(ЭтаФорма));
	
	Если ЗначениеЗаполнено(ОсновноеСредство) Тогда
		
		ЗаполнитьПоНаименованиюСервер(ОсновноеСредство);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подбор(Команда)
	
	ПараметрыОтбор = Новый Структура;
	ПараметрыОтбор.Вставить("БУСостояние", ПредопределенноеЗначение("Перечисление.СостоянияОС.ПринятоКУчету"));
	ПараметрыОтбор.Вставить("БУОрганизация", Объект.Организация);
	ПараметрыОтбор.Вставить("БУПодразделение", Объект.Подразделение);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Контекст", "БУ, МФУ");
	ПараметрыФормы.Вставить("ДатаСведений", Объект.Дата);
	ПараметрыФормы.Вставить("ТекущийРегистратор", Объект.Ссылка);
	ПараметрыФормы.Вставить("Отбор", ПараметрыОтбор);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Ложь);
	
	ОткрытьФорму("Справочник.ОбъектыЭксплуатации.ФормаВыбора", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

#Область ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

#КонецОбласти

#Область СтандартныеПодсистемы_ДополнительныеОтчетыИОбработки

&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры

#КонецОбласти

#Область СтандартныеПодсистемы_Печать

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	#Область ОбязательностьЗаполненияАналитикаРасходов
	
	ПланыВидовХарактеристик.СтатьиРасходов.УстановитьУсловноеОформлениеАналитик(УсловноеОформление);
	
	#КонецОбласти
	
	#Область ОбязательностьЗаполненияРеквизитовПередачи
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("ДатаПередачи");
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("СтатьяРасходов");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.ПередачаВыполнена");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
	#КонецОбласти
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	ЗаполнитьИнвентарныеНомера();
	
	Если Объект.ПоддержкаОтложенногоПереходаПрав Тогда
		Элементы.СтатьяРасходов.Видимость = Ложь;
		Элементы.АналитикаРасходов.Видимость = Ложь;
	Иначе
		СтатьяРасходовПриИзмененииНаСервере();
	КонецЕсли;
	
	ВалютаДокумента = Объект.Валюта;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИнвентарныеНомера()
	
	ТаблицаОС = Объект.ОС.Выгрузить(, "НомерСтроки, ОсновноеСредство");
	
	ТаблицаНомеров = УчетОСВызовСервера.ПолучитьТаблицуИнвентарныхНомеровОС(ТаблицаОС, Объект.Организация, Объект.Дата);
	
	Для Каждого Строка Из ТаблицаНомеров Цикл
		Объект.ОС[Строка.НомерСтроки-1].ИнвентарныйНомер = Строка.ИнвентарныйНомер;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПараметрыЗаполненияПоНаименованию(Форма)
	
	Результат = Новый Структура;
	Результат.Вставить("Форма", Форма);
	Результат.Вставить("Объект", Форма.Объект);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьПоНаименованиюСервер(Знач ОсновноеСредство)
	
	УчетОСВызовСервера.ДозаполнитьТабличнуюЧастьОсновнымиСредствамиПоНаименованию(
		ПараметрыЗаполненияПоНаименованию(ЭтаФорма), ОсновноеСредство);
	
КонецПроцедуры

&НаСервере
Процедура СтатьяРасходовПриИзмененииНаСервере()
	
	АналитикаРасходовОбязательна =
		ЗначениеЗаполнено(Объект.СтатьяРасходов)
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.СтатьяРасходов, "КонтролироватьЗаполнениеАналитики");
	
КонецПроцедуры

&НаСервере
Процедура ВалютаПриИзмененииСервер(ВалютаСтарая, ВалютаНовая)
	
	ДатаДокумента = ?(ЗначениеЗаполнено(Объект.Дата), Объект.Дата, ТекущаяДатаСеанса());
	КурсыСтарые = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаСтарая, ДатаДокумента);
	КурсыНовые  = РаботаСКурсамиВалют.ПолучитьКурсВалюты(ВалютаНовая, ДатаДокумента);
	Ценообразование.ПересчитатьСуммыТабличнойЧастиВВалюту(
		Объект.ОС, Объект.ЦенаВключаетНДС, ВалютаСтарая, ВалютаНовая, КурсыСтарые, КурсыНовые, , , "Количество");
	
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьСуммыПоВалюте()
	
	Если ЗначениеЗаполнено(Объект.Валюта) И ВалютаДокумента<>Объект.Валюта И Объект.ОС.Количество()>0 Тогда
		ВалютаПриИзмененииСервер(ВалютаДокумента, Объект.Валюта);
		ЦенообразованиеКлиент.ОповеститьОбОкончанииПересчетаСуммВВалюту(ВалютаДокумента, Объект.Валюта);
	КонецЕсли;
	ВалютаДокумента = Объект.Валюта;
	
КонецПроцедуры

&НаСервере
Процедура ЦенаВключаетНДСПриИзмененииСервер(КэшЗначений)
	ДействияПересчета = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруПересчетаСуммыНДСВТЧ(Объект);
	Действия = Новый Структура;
	Действия.Вставить("ПересчитатьСуммуНДС", ДействияПересчета);
	Действия.Вставить("ПересчитатьСуммуСНДС", ДействияПересчета);
	ОбработкаТабличнойЧастиСервер.ОбработатьТЧ(Объект.ОС, Действия, КэшЗначений);
КонецПроцедуры

&НаСервере
Процедура НалогообложениеНДСПриИзмененииСервер()
	
	ДействияПересчета = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруПересчетаСуммыНДСВТЧ(Объект);
	Действия = Новый Структура();
	Действия.Вставить("ПересчитатьСуммуНДС", ДействияПересчета);
	Действия.Вставить("ПересчитатьСуммуСНДС", ДействияПересчета);
	Если Перечисления.ТипыНалогообложенияНДС.ПродажаНеОблагаетсяНДС=Объект.НалогообложениеНДС
		Или Перечисления.ТипыНалогообложенияНДС.ПродажаНаЭкспорт=Объект.НалогообложениеНДС
	Тогда
		Действия.Вставить("ЗаполнитьСтавкуНДС", Объект.НалогообложениеНДС);
	КонецЕсли;
	ОбработкаТабличнойЧастиСервер.ОбработатьТЧ(Объект.ОС, Действия, Неопределено);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ДобавитьДействияПересчетаНДС(Действия, Объект)
	
	ДействияПересчета = ОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруПересчетаСуммыНДСВСтрокеТЧ(Объект);
	Действия.Вставить("ПересчитатьСуммуНДС", ДействияПересчета);
	Действия.Вставить("ПересчитатьСуммуСНДС", ДействияПересчета);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ДобавитьДействияПересчетаСумм(Действия, Объект)
	
	ДобавитьДействияПересчетаНДС(Действия, Объект);
	Действия.Вставить("ПересчитатьСумму", "Количество");
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СоздатьСтрокуПересчетаСумм(ТекущаяСтрокаОС)
	
	Структура = Новый Структура("Количество, КоличествоУпаковок, Цена, Сумма, СуммаНДС, СуммаСНДС, СтавкаНДС");
	ЗаполнитьЗначенияСвойств(Структура, ТекущаяСтрокаОС);
	Структура.Цена = Структура.Сумма;
	Структура.Количество = 1;
	Структура.КоличествоУпаковок = 1;
	
	Возврат Структура;
	
КонецФункции

#КонецОбласти
