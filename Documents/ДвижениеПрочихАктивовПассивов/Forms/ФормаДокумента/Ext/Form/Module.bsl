﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	ДополнительныеПараметры.Вставить("ОтложеннаяИнициализация", Истина);
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	Если ТекущийВариантИнтерфейсаКлиентскогоПриложения() = ВариантИнтерфейсаКлиентскогоПриложения.Версия8_2 Тогда
		Элементы.ГруппаИтого.ЦветФона = Новый Цвет();
	КонецЕсли;
	
	// Контроль создания документа в подчиенном узле РИБ с фильтрами
	ОбменДаннымиУТУП.КонтрольСозданияДокументовВРаспределеннойИБ(Объект, Отказ);
	
	ОписанияДвижений = Новый ФиксированноеСоответствие(Документы.ДвижениеПрочихАктивовПассивов.ОписаниеДвижений());
	Описание = СформироватьОписание(Объект, Элементы, ОписанияДвижений);
	Источник = Объект.Источник;
	Получатель = Объект.Получатель;
	
	Если Объект.Ссылка.Пустая() Тогда
		ОбновитьОписание(Объект, Элементы, Объект.Описание, ОписанияДвижений);
	Иначе
		МассивИмен = Новый Массив(1);
		МассивИмен[0] = Описание;
		Элементы.Описание.СписокВыбора.ЗагрузитьЗначения(МассивИмен);
	КонецЕсли;
	
	УстановитьВидимость();
	
	ПоляАналитик = "СтатьяИсточник, АналитикаРасходовЗаказРеализацияИсточник, СтатьяПолучатель, АналитикаРасходовЗаказРеализацияПолучатель";
	ПланыВидовХарактеристик.СтатьиРасходов.ЗаполнитьПризнакАналитикаРасходовЗаказРеализация(Объект.ДанныеОтражения, ПоляАналитик);
	
	// ВводНаОсновании
	ВводНаОсновании.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюСоздатьНаОсновании);
	// Конец ВводНаОсновании

	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Элементы.СтраницаКомментарий.Картинка = ОбщегоНазначенияКлиентСервер.КартинкаКомментария(Объект.Комментарий);
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
	Описание = СформироватьОписание(Объект, Элементы, ОписанияДвижений);
	Источник = Объект.Источник;
	Получатель = Объект.Получатель;
	
	УстановитьВидимость();
	
	ПланыВидовХарактеристик.СтатьиРасходов.ЗаполнитьПризнакАналитикаРасходовОбязательна(
		Объект.ДанныеОтражения,
		"СтатьяИсточник, АналитикаРасходовИсточник, СтатьяПолучатель, АналитикаРасходовПолучатель");
	
	ПланыВидовХарактеристик.СтатьиДоходов.ЗаполнитьПризнакАналитикаДоходовОбязательна(
		Объект.ДанныеОтражения,
		"СтатьяИсточник, АналитикаДоходовИсточник, СтатьяПолучатель, АналитикаДоходовПолучатель");
		
	ПланыВидовХарактеристик.СтатьиРасходов.ЗаполнитьПризнакАналитикаРасходовЗаказРеализация(
		Объект.ДанныеОтражения,
		"СтатьяИсточник, АналитикаРасходовЗаказРеализацияИсточник, СтатьяПолучатель, АналитикаРасходовЗаказРеализацияПолучатель");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства

	РассчитатьИтоговыеПоказатели();

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, ИсточникОповещения)
	
	// СтандартныеПодсистемы.Свойства 
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	ПланыВидовХарактеристик.СтатьиРасходов.ЗаполнитьПризнакАналитикаРасходовОбязательна(
		Объект.ДанныеОтражения,
		"СтатьяИсточник, АналитикаРасходовИсточник, СтатьяПолучатель, АналитикаРасходовПолучатель");
	
	ПланыВидовХарактеристик.СтатьиДоходов.ЗаполнитьПризнакАналитикаДоходовОбязательна(
		Объект.ДанныеОтражения,
		"СтатьяИсточник, АналитикаДоходовИсточник, СтатьяПолучатель, АналитикаДоходовПолучатель");
		
	ПланыВидовХарактеристик.СтатьиРасходов.ЗаполнитьПризнакАналитикаРасходовЗаказРеализация(
		Объект.ДанныеОтражения,
		"СтатьяИсточник, АналитикаРасходовЗаказРеализацияИсточник, СтатьяПолучатель, АналитикаРасходовЗаказРеализацияПолучатель");
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);

	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ИсточникВыбора.ИмяФормы = "Документ.ДвижениеПрочихАктивовПассивов.Форма.ФормаПодбораДвижений" Тогда
		ОбработкаПодбораОстатков(ВыбранноеЗначение.АдресОстатковВХранилище);
	ИначеЕсли ИсточникВыбора.ИмяФормы = "Документ.ДвижениеПрочихАктивовПассивов.Форма.ФормаПодбораТиповДвижений" Тогда
		ОбработкаПодбораТипаДвижений(ВыбранноеЗначение);
	КонецЕсли;
	
	Если Окно <> Неопределено Тогда
		Окно.Активизировать();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	// СтандартныеПодсистемы.Свойства
	Если ТекущаяСтраница.Имя = "ГруппаДополнительныеРеквизиты"
		И Не ЭтотОбъект.ПараметрыСвойств.ВыполненаОтложеннаяИнициализация Тогда
		
		СвойстваВыполнитьОтложеннуюИнициализацию();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОткрытьФорму("Документ.ДвижениеПрочихАктивовПассивов.Форма.ФормаПодбораТиповДвижений", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеПриИзменении(Элемент)
	
	Если Объект.Описание = СформироватьОписание(Объект, Элементы, ОписанияДвижений) Тогда
		Описание = Объект.Описание;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсточникПриИзменении(Элемент)
	
	Если Не НужноУточнитьИзменениеТипаДвижений(Источник, Получатель, "ОтветНаВопросИзмененияИсточника") Тогда
		ОбновитьОписание(Объект, Элементы, Описание, ОписанияДвижений);
		Источник = Объект.Источник;
		УстановитьВидимость();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучательПриИзменении(Элемент)
	
	Если Объект.Получатель = ПредопределенноеЗначение("Перечисление.ТипыСтатейАктивовПассивов.СтатьяПассивов") 
		И Объект.Источник = ПредопределенноеЗначение("Перечисление.ТипыСтатейАктивовПассивов.СтатьяАктивов") Тогда
		Объект.Источник = ПредопределенноеЗначение("Перечисление.ТипыСтатейАктивовПассивов.СтатьяПассивов");
	КонецЕсли;
	Если Не НужноУточнитьИзменениеТипаДвижений(Источник, Получатель, "ОтветНаВопросИзмененияПолучателя") Тогда
		ОбновитьОписание(Объект, Элементы, Описание, ОписанияДвижений);
		Получатель = Объект.Получатель;
		УстановитьВидимость();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура ДанныеОтраженияПриИзменении(Элемент)
	
	РассчитатьИтоговыеПоказатели();
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеОтраженияСтатьяПолучательПриИзменении(Элемент)
	
	ДанныеОтраженияСтатьяПолучательПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ДанныеОтраженияСтатьяПолучательПриИзмененииНаСервере()
	
	Если Элементы.ДанныеОтражения.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаТаблицы = Объект.ДанныеОтражения.НайтиПоИдентификатору(Элементы.ДанныеОтражения.ТекущаяСтрока);
	СтатьяАктивовПассивовПриИзмененииСервер(СтрокаТаблицы.СтатьяПолучатель, СтрокаТаблицы.АналитикаАктивовПассивовПолучатель);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьПризнакАналитикаДоходовОбязательна", "СтатьяПолучатель, АналитикаДоходовПолучатель");
	СтруктураДействий.Вставить("ЗаполнитьПризнакАналитикаРасходовОбязательна", "СтатьяПолучатель, АналитикаРасходовПолучатель");
	Если ТипЗнч(СтрокаТаблицы.СтатьяПолучатель) = Тип("ПланВидовХарактеристикСсылка.СтатьиРасходов") Тогда
		ДоходыИРасходыСервер.СтатьяРасходовПриИзменении(Объект, СтрокаТаблицы.СтатьяПолучатель, СтрокаТаблицы.АналитикаРасходовПолучатель);
		СтуктураПолей = Новый Структура("СтатьяИсточник, СтатьяПолучатель", "АналитикаРасходовЗаказРеализацияИсточник", "АналитикаРасходовЗаказРеализацияПолучатель");
		СтруктураДействий.Вставить("ЗаполнитьПризнакАналитикаРасходовЗаказРеализация", СтуктураПолей);
	КонецЕсли;
	ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(СтрокаТаблицы, СтруктураДействий, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеОтраженияСтатьяИсточникПриИзменении(Элемент)
	
	ДанныеОтраженияСтатьяИсточникПриИзмененииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ДанныеОтраженияСтатьяИсточникПриИзмененииНаСервере()
	
	Если Элементы.ДанныеОтражения.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаТаблицы = Объект.ДанныеОтражения.НайтиПоИдентификатору(Элементы.ДанныеОтражения.ТекущаяСтрока);
	СтатьяАктивовПассивовПриИзмененииСервер(СтрокаТаблицы.СтатьяИсточник, СтрокаТаблицы.АналитикаАктивовПассивовИсточник);
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьПризнакАналитикаДоходовОбязательна", "СтатьяИсточник, АналитикаДоходовИсточник");
	СтруктураДействий.Вставить("ЗаполнитьПризнакАналитикаРасходовОбязательна", "СтатьяИсточник, АналитикаРасходовИсточник");
	Если ТипЗнч(СтрокаТаблицы.СтатьяИсточник) = Тип("ПланВидовХарактеристикСсылка.СтатьиРасходов") Тогда
		ДоходыИРасходыСервер.СтатьяРасходовПриИзменении(Объект, СтрокаТаблицы.СтатьяИсточник, СтрокаТаблицы.АналитикаРасходовИсточник);
		СтуктураПолей = Новый Структура("СтатьяИсточник, СтатьяПолучатель", "АналитикаРасходовЗаказРеализацияИсточник", "АналитикаРасходовЗаказРеализацияПолучатель");
		СтруктураДействий.Вставить("ЗаполнитьПризнакАналитикаРасходовЗаказРеализация", СтуктураПолей);
	КонецЕсли;
	ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(СтрокаТаблицы, СтруктураДействий, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеОтраженияАналитикаРасходовИсточникНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтрокаТаблицы = Элементы.ДанныеОтражения.ТекущиеДанные;
	Если СтрокаТаблицы.АналитикаРасходовЗаказРеализацияИсточник Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьФорму("ОбщаяФорма.ВыборАналитикиРасходов", , Элемент);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДанныеОтраженияАналитикаРасходовИсточникОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СтрокаТаблицы = Элементы.ДанныеОтражения.ТекущиеДанные;
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		СтрокаТаблицы.АналитикаРасходовИсточник = ВыбранноеЗначение.АналитикаРасходов;
		СтандартнаяОбработка = Ложь;
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДанныеОтраженияАналитикаРасходовИсточникАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДанныеОтраженияАналитикаРасходовИсточникОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДанныеОтраженияАналитикаРасходовПолучательНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтрокаТаблицы = Элементы.ДанныеОтражения.ТекущиеДанные;
	Если СтрокаТаблицы.АналитикаРасходовЗаказРеализацияПолучатель Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьФорму("ОбщаяФорма.ВыборАналитикиРасходов", , Элемент);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДанныеОтраженияАналитикаРасходовПолучательОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СтрокаТаблицы = Элементы.ДанныеОтражения.ТекущиеДанные;
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		СтрокаТаблицы.АналитикаРасходовПолучатель = ВыбранноеЗначение.АналитикаРасходов;
		СтандартнаяОбработка = Ложь;
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДанныеОтраженияАналитикаРасходовПолучательАвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДанныеОтраженияАналитикаРасходовПолучательОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, Параметры, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Текст) Тогда
		СтандартнаяОбработка = Ложь;
		АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// ВводНаОсновании
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
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
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСтатьюПрихода(Команда)
	
	ЗаполнитьСтатьюВТаблице("Получатель");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСтатьюРасхода(Команда)
	
	ЗаполнитьСтатьюВТаблице("Источник");
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборОстатковИсточника(Команда)
	
	ПодборОстатков("Источник");
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборОстатковПолучателя(Команда)
	
	ПодборОстатков("Получатель");
	ДанныеОтраженияСтатьяПолучательПриИзмененииНаСервере();
	
КонецПроцедуры

// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств()
	
	УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтаФорма, Объект.Ссылка);
	
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

&НаСервереБезКонтекста
Процедура АналитикаРасходовПолучениеДанныхВыбора(ДанныеВыбора, Текст)
	
	ДанныеВыбора = Новый СписокЗначений;
	ПродажиСервер.ЗаполнитьДанныеВыбораАналитикиРасходов(ДанныеВыбора, Текст);
	
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

&НаКлиенте
Процедура ЗаполнитьСтатьюВТаблице(СторонаТаблицы)
	
	ВыделенныеСтроки = Элементы.ДанныеОтражения.ВыделенныеСтроки;
	
	Если Объект.ДанныеОтражения.Количество() = 0 ИЛИ НЕ ЗначениеЗаполнено(ВыделенныеСтроки) Тогда
		Текст = НСтр("ru = 'Для выполнения команды требуется выделить строки табличной части.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст);
		Возврат;
	КонецЕсли;
	
	Если Объект[СторонаТаблицы] = ПредопределенноеЗначение("Перечисление.ТипыСтатейАктивовПассивов.СтатьяРасходов") Тогда
		ВыбранноеЗначение = Неопределено;

		ОткрытьФорму(
			"ПланВидовХарактеристик.СтатьиРасходов.Форма.ФормаВыбораСтатьиИАналитики", 
			,
			ЭтаФорма,,,, Новый ОписаниеОповещения("ЗаполнитьСтатьюВТаблицеЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки, СторонаТаблицы", ВыделенныеСтроки, СторонаТаблицы)), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
        Возврат;
	ИначеЕсли Объект[СторонаТаблицы] = ПредопределенноеЗначение("Перечисление.ТипыСтатейАктивовПассивов.СтатьяДоходов") Тогда
		ОткрытьФорму(
			"ПланВидовХарактеристик.СтатьиДоходов.Форма.ФормаВыбораСтатьиИАналитики", 
			,
			ЭтаФорма,,,, Новый ОписаниеОповещения("ЗаполнитьСтатьюВТаблицеЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки, СторонаТаблицы", ВыделенныеСтроки, СторонаТаблицы)), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
        Возврат;
	ИначеЕсли Объект[СторонаТаблицы] = ПредопределенноеЗначение("Перечисление.ТипыСтатейАктивовПассивов.СтатьяПассивов") Тогда
		ОткрытьФорму(
			"ПланВидовХарактеристик.СтатьиАктивовПассивов.Форма.ФормаВыбораСтатьиИАналитики", 
			Новый Структура("АктивПассив", ПредопределенноеЗначение("Перечисление.ВидыСтатейУправленческогоБаланса.Пассив")),
			ЭтаФорма,,,, Новый ОписаниеОповещения("ЗаполнитьСтатьюВТаблицеЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки, СторонаТаблицы", ВыделенныеСтроки, СторонаТаблицы)), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
        Возврат;
	Иначе
		ОткрытьФорму(
			"ПланВидовХарактеристик.СтатьиАктивовПассивов.Форма.ФормаВыбораСтатьиИАналитики", 
			Новый Структура("АктивПассив", ПредопределенноеЗначение("Перечисление.ВидыСтатейУправленческогоБаланса.Актив")),
			ЭтаФорма,,,, Новый ОписаниеОповещения("ЗаполнитьСтатьюВТаблицеЗавершение", ЭтотОбъект, Новый Структура("ВыбранноеЗначение, ВыделенныеСтроки, СторонаТаблицы", ВыбранноеЗначение, ВыделенныеСтроки, СторонаТаблицы)), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
        Возврат;
	КонецЕсли;
	
	ЗаполнитьСтатьюВТаблицеФрагмент(ВыбранноеЗначение, ВыделенныеСтроки, СторонаТаблицы);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСтатьюВТаблицеЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
    СторонаТаблицы = ДополнительныеПараметры.СторонаТаблицы;
    
    
    ВыбранноеЗначение = Результат;
    
    ЗаполнитьСтатьюВТаблицеФрагмент(ВыбранноеЗначение, ВыделенныеСтроки, СторонаТаблицы);

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСтатьюВТаблицеФрагмент(Знач ВыбранноеЗначение, Знач ВыделенныеСтроки, Знач СторонаТаблицы)
    
    Перем Строка, СтрокаТаблицы;
    
    Если ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
        
        Для Каждого Строка Из ВыделенныеСтроки Цикл
            
            СтрокаТаблицы = Объект.ДанныеОтражения.НайтиПоИдентификатору(Строка);
            
            Если СтрокаТаблицы <> Неопределено Тогда
                Если Объект[СторонаТаблицы] = ПредопределенноеЗначение("Перечисление.ТипыСтатейАктивовПассивов.СтатьяРасходов") Тогда
                    СтрокаТаблицы["Статья" + СторонаТаблицы] = ВыбранноеЗначение.СтатьяРасходов;
                    СтрокаТаблицы["АналитикаРасходов" + СторонаТаблицы] = ВыбранноеЗначение.АналитикаРасходов;
                ИначеЕсли Объект[СторонаТаблицы] = ПредопределенноеЗначение("Перечисление.ТипыСтатейАктивовПассивов.СтатьяДоходов") Тогда
                    СтрокаТаблицы["Статья" + СторонаТаблицы] = ВыбранноеЗначение.СтатьяДоходов;
                    СтрокаТаблицы["АналитикаДоходов" + СторонаТаблицы] = ВыбранноеЗначение.АналитикаДоходов;
                Иначе
                    СтрокаТаблицы["Статья" + СторонаТаблицы] = ВыбранноеЗначение.Статья;
                    СтрокаТаблицы["АналитикаАктивовПассивов" + СторонаТаблицы] = ВыбранноеЗначение.Аналитика;
                КонецЕсли;
            КонецЕсли;
            
        КонецЦикла;
        
    КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	
	Реквизиты = Новый Структура(
		"ДанныеОтражения",
		"СтатьяИсточник, АналитикаРасходовИсточник, СтатьяПолучатель, АналитикаРасходовПолучатель");
	ПланыВидовХарактеристик.СтатьиРасходов.УстановитьУсловноеОформлениеАналитик(УсловноеОформление, Реквизиты);
	
	//
	
	Реквизиты = Новый Структура(
		"ДанныеОтражения",
		"СтатьяИсточник, АналитикаДоходовИсточник, СтатьяПолучатель, АналитикаДоходовПолучатель");
	ПланыВидовХарактеристик.СтатьиДоходов.УстановитьУсловноеОформлениеАналитик(УсловноеОформление, Реквизиты);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаПодбораТипаДвижений(ТипДвижений)
	
	Если Не ТипЗнч(ТипДвижений) = Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не НужноУточнитьИзменениеТипаДвижений(ТипДвижений.Источник, ТипДвижений.Получатель, "ОтветНаВопросИзмененияТипаДвижений", ТипДвижений) Тогда
		ЗаполнитьЗначенияСвойств(Объект, ТипДвижений);
		УстановитьВидимость();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция НужноУточнитьИзменениеТипаДвижений(ЗнИсточник, ЗнПолучатель, Обработчик, ПараметрыОбработчика = Неопределено)
	
	Если Объект.ДанныеОтражения.Количество()
		И НЕ (Объект.Источник = ЗнИсточник И Объект.Получатель = ЗнПолучатель) Тогда
		
		ТекстВопроса = НСтр("ru = 'Табличная часть документа будет очищена, продолжить?'");
		Оповещение = Новый ОписаниеОповещения(Обработчик, ЭтаФорма, ПараметрыОбработчика);
		
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
		Возврат Истина;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

&НаКлиенте
Процедура ОтветНаВопросИзмененияТипаДвижений(Результат, ТипДвижений) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	Объект.ДанныеОтражения.Очистить();
	Если Не ТипДвижений = Неопределено Тогда
		ЗаполнитьЗначенияСвойств(Объект, ТипДвижений);
	КонецЕсли;
	
	УстановитьВидимость();
	
КонецПроцедуры 

&НаКлиенте
Процедура ОтветНаВопросИзмененияИсточника(Результат, ДопПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Объект.Источник = Источник;
	Иначе
		ОбновитьОписание(Объект, Элементы, Описание, ОписанияДвижений);
		Объект.ДанныеОтражения.Очистить();
		Источник = Объект.Источник;
		УстановитьВидимость();
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура ОтветНаВопросИзмененияПолучателя(Результат, ДопПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Объект.Получатель = Получатель;
	Иначе
		ОбновитьОписание(Объект, Элементы, Описание, ОписанияДвижений);
		Объект.ДанныеОтражения.Очистить();
		Получатель = Объект.Получатель;
		УстановитьВидимость();
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьОписание(Объект, Элементы, ПрежнееИмя, ОписанияДвижений)
	
	// Новое имя элемента
	НовоеИмя = СформироватьОписание(Объект, Элементы, ОписанияДвижений);
	
	Если ПустаяСтрока(Объект.Описание) Или Объект.Описание = ПрежнееИмя Тогда
		Объект.Описание = НовоеИмя;
	КонецЕсли;
	
	ПрежнееИмя = НовоеИмя;
	
	// Список имен
	МассивИмен = Новый Массив(1);
	МассивИмен[0] = НовоеИмя;
	
	Элементы.Описание.СписокВыбора.ЗагрузитьЗначения(МассивИмен);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СформироватьОписание(Объект, Элементы, ОписанияДвижений)
	
	Если Объект.Получатель = ПредопределенноеЗначение("Перечисление.ТипыСтатейАктивовПассивов.СтатьяДоходов")
		ИЛИ Объект.Получатель = ПредопределенноеЗначение("Перечисление.ТипыСтатейАктивовПассивов.СтатьяРасходов")
		ИЛИ (Объект.Получатель = ПредопределенноеЗначение("Перечисление.ТипыСтатейАктивовПассивов.СтатьяПассивов")
			И Объект.Источник = ПредопределенноеЗначение("Перечисление.ТипыСтатейАктивовПассивов.СтатьяАктивов")) Тогда
		Возврат Неопределено;
	КонецЕсли;
	Идентификатор = Строка(Объект.Получатель) + "\" + Строка(Объект.Источник);
	Возврат ОписанияДвижений[Идентификатор];
	
КонецФункции

&НаСервере
Функция ДанныеСтороныТипаДвижений(ТипСтатьи, Постфикс = "")
	
	// Инициализация структуры
	Данные = Новый Структура;
	Данные.Вставить("Имя", "");
	Данные.Вставить("Тип", Неопределено);
	Данные.Вставить("Отбор", Новый Массив);
	Данные.Вставить("ОтборНаправления", Новый Массив);
	
	АктивПассив = Новый Массив;
	АктивПассив.Добавить(Перечисления.ВидыСтатейУправленческогоБаланса.АктивПассив);
	Если ТипСтатьи = Перечисления.ТипыСтатейАктивовПассивов.СтатьяДоходов Тогда
		
		Данные.Имя = НСтр("ru = 'доходов'") + Постфикс;
		Данные.Тип = Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.СтатьиДоходов");
		Данные.ОтборНаправления.Добавить(Новый ПараметрВыбора("Отбор.УчетДоходов", Истина));
		
	ИначеЕсли ТипСтатьи = Перечисления.ТипыСтатейАктивовПассивов.СтатьяРасходов Тогда
		
		Данные.Имя = НСтр("ru = 'расходов'") + Постфикс;
		Данные.Тип = Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.СтатьиРасходов");
		Данные.ОтборНаправления.Добавить(Новый ПараметрВыбора("Отбор.УчетЗатрат", Истина));
		
	ИначеЕсли ТипСтатьи = Перечисления.ТипыСтатейАктивовПассивов.СтатьяПассивов Тогда
		
		Данные.Имя = НСтр("ru = 'пассивов'") + Постфикс;
		Данные.Тип = Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.СтатьиАктивовПассивов");
		АктивПассив.Добавить(Перечисления.ВидыСтатейУправленческогоБаланса.Пассив);
		Данные.Отбор.Добавить(Новый ПараметрВыбора("Отбор.АктивПассив", АктивПассив));
		Данные.ОтборНаправления.Добавить(Новый ПараметрВыбора("Ссылка", Объект.Ссылка));
		
	Иначе
		
		Данные.Имя = НСтр("ru = 'активов'") + Постфикс;
		Данные.Тип = Новый ОписаниеТипов("ПланВидовХарактеристикСсылка.СтатьиАктивовПассивов");
		АктивПассив.Добавить(Перечисления.ВидыСтатейУправленческогоБаланса.Актив);
		Данные.Отбор.Добавить(Новый ПараметрВыбора("Отбор.АктивПассив", АктивПассив));
		Данные.ОтборНаправления.Добавить(Новый ПараметрВыбора("Ссылка", Объект.Ссылка));
		
	КонецЕсли;
	
	Возврат Данные;
	
КонецФункции

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	Элементы.Валюта.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют");
	
	ПостфиксИсточника = "";
	ПостфиксПолучателя = "";
	Если Объект.Источник = Объект.Получатель Тогда
		ПостфиксИсточника  = " " + ?(Объект.Увеличение, НСтр("ru = '(Расход)'"), НСтр("ru = '(Приход)'"));
		ПостфиксПолучателя = " " + ?(Объект.Увеличение, НСтр("ru = '(Приход)'"), НСтр("ru = '(Расход)'"));
	КонецЕсли;
	
	ДанныеИсточника = ДанныеСтороныТипаДвижений(Объект.Источник, ПостфиксИсточника);
	ДанныеПолучателя = ДанныеСтороныТипаДвижений(Объект.Получатель, ПостфиксПолучателя);
	
	// Получатель
	Элементы.ДанныеОтраженияПодборОстатковПолучателя.Заголовок	= НСтр("ru = 'Подбор'") + " " + ДанныеПолучателя.Имя;
	Элементы.ДанныеОтраженияПодборОстатковПолучателя.Видимость	= Не Объект.Увеличение;
	Элементы.ДанныеОтраженияСтатьяПолучатель.Заголовок			= НСтр("ru = 'Статья'") +" " +  ДанныеПолучателя.Имя;
	Элементы.ДанныеОтраженияСтатьяПолучатель.ОграничениеТипа	= ДанныеПолучателя.Тип;
	Элементы.ДанныеОтраженияСтатьяПолучатель.ПараметрыВыбора	= Новый ФиксированныйМассив(ДанныеПолучателя.Отбор);
	Элементы.ДанныеОтраженияЗаполнитьСтатьюПолучатель.Заголовок	= НСтр("ru = 'Статью'") + " " + ДанныеПолучателя.Имя;
	Элементы.ДанныеОтраженияПодразделениеПолучатель.Заголовок	= НСтр("ru = 'Подразделение'") + " " + ДанныеПолучателя.Имя;
	Элементы.ДанныеОтраженияНаправлениеПолучатель.Заголовок	= НСтр("ru = 'Направление деятельности'") + " " + ДанныеПолучателя.Имя;
	Элементы.ДанныеОтраженияНаправлениеПолучатель.ПараметрыВыбора = Новый ФиксированныйМассив(ДанныеПолучателя.ОтборНаправления);
	
	// Источник
	Элементы.ДанныеОтраженияПодборОстатковИсточника.Заголовок	= НСтр("ru = 'Подбор'") + " " + ДанныеИсточника.Имя;
	Элементы.ДанныеОтраженияПодборОстатковИсточника.Видимость	= Объект.Увеличение;
	Элементы.ДанныеОтраженияСтатьяИсточник.Заголовок			= НСтр("ru = 'Статья'") + " " + ДанныеИсточника.Имя;
	Элементы.ДанныеОтраженияСтатьяИсточник.ОграничениеТипа		= ДанныеИсточника.Тип;
	Элементы.ДанныеОтраженияСтатьяИсточник.ПараметрыВыбора		= Новый ФиксированныйМассив(ДанныеИсточника.Отбор);
	Элементы.ДанныеОтраженияЗаполнитьСтатьюИсточник.Заголовок	= НСтр("ru = 'Статью'") + " " + ДанныеИсточника.Имя;
	Элементы.ДанныеОтраженияПодразделениеИсточник.Заголовок		= НСтр("ru = 'Подразделение'") + " " + ДанныеИсточника.Имя;
	Элементы.ДанныеОтраженияНаправлениеИсточник.Заголовок	= НСтр("ru = 'Направление деятельности'") + " " + ДанныеИсточника.Имя;
	Элементы.ДанныеОтраженияНаправлениеИсточник.ПараметрыВыбора = Новый ФиксированныйМассив(ДанныеИсточника.ОтборНаправления);
	
	Элементы.ДанныеОтраженияПодразделениеИсточник.АвтоОтметкаНезаполненного = Неопределено;
	Если Источник = Перечисления.ТипыСтатейАктивовПассивов.СтатьяАктивов
		ИЛИ Источник = Перечисления.ТипыСтатейАктивовПассивов.СтатьяПассивов Тогда
		Элементы.ДанныеОтраженияПодразделениеИсточник.АвтоОтметкаНезаполненного = Ложь;
	КонецЕсли;
	
	ЗаполнитьПредставлениеИсточников();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()
	
	Перем МассивВсехРеквизитов;
	Перем МассивРеквизитовОперации;
	
	Документы.ДвижениеПрочихАктивовПассивов.ЗаполнитьИменаРеквизитовПоХозяйственнойОперации(
		Объект.Источник,
		Объект.Получатель,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	
	ДенежныеСредстваСервер.УстановитьВидимостьЭлементовПоМассиву(
		Элементы,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
	
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьИтоговыеПоказатели()
	
	ВсегоСумма = Объект.ДанныеОтражения.Итог("Сумма");
	
КонецПроцедуры

&НаСервере
Процедура СтатьяАктивовПассивовПриИзмененииСервер(СтатьяАктивовПассивов, АналитикаАктивовПассивов)
	
	ДоходыИРасходыСервер.СтатьяАктивовПассивовПриИзменении(
		Объект,
		СтатьяАктивовПассивов,
		АналитикаАктивовПассивов);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборОстатков(ТипСтатьи)
	
	СтатьяАктивов = ПредопределенноеЗначение("Перечисление.ТипыСтатейАктивовПассивов.СтатьяАктивов");
	
	ПараметрыПодбора = Новый Структура;
	ПараметрыПодбора.Вставить("СторонаТаблицы",	ТипСтатьи);
	ПараметрыПодбора.Вставить("Валюта",			Объект.Валюта);
	ПараметрыПодбора.Вставить("ДокументСсылка",	Объект.Ссылка);
	ПараметрыПодбора.Вставить("Организация",	Объект.Организация);
	ПараметрыПодбора.Вставить("ТипСтатьи",		?(Объект[ТипСтатьи].Пустая(), СтатьяАктивов, Объект[ТипСтатьи]));
	ПараметрыПодбора.Вставить("Дата",			Объект.Дата);
	
	ОткрытьФорму("Документ.ДвижениеПрочихАктивовПассивов.Форма.ФормаПодбораДвижений",
		ПараметрыПодбора,
		ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПодбораОстатков(АдресОстатковВХранилище) 
	
	ТаблицаОстатков = ПолучитьИзВременногоХранилища(АдресОстатковВХранилище);
	
	Если Не ТаблицаОстатков = Неопределено Тогда
		
		Для Каждого СтрокаОстатков Из ТаблицаОстатков Цикл
			ЗаполнитьЗначенияСвойств(Объект.ДанныеОтражения.Добавить(), СтрокаОстатков);
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, 
		ЭтотОбъект, 
		"Объект.Описание");
	
КонецПроцедуры

//&НаКлиентеНаСервереБезКонтекста
&НаСервере
Процедура ЗаполнитьПредставлениеИсточников()
	
	СписокВыбора = Элементы.Источник.СписокВыбора;
	СписокВыбора.Очистить();
	Если Получатель = Перечисления.ТипыСтатейАктивовПассивов.СтатьяАктивов Тогда
		
		СписокВыбора.Добавить(Перечисления.ТипыСтатейАктивовПассивов.СтатьяАктивов,  НСтр("ru = 'уменьшение других активов'"));
		СписокВыбора.Добавить(Перечисления.ТипыСтатейАктивовПассивов.СтатьяПассивов, НСтр("ru = 'увеличение пассивов'"));
		СписокВыбора.Добавить(Перечисления.ТипыСтатейАктивовПассивов.СтатьяРасходов, НСтр("ru = 'уменьшения расходов'"));
		СписокВыбора.Добавить(Перечисления.ТипыСтатейАктивовПассивов.СтатьяДоходов,  НСтр("ru = 'возникновение доходов'"));
		Объект.Получатель = СписокВыбора[0].Значение;
		
	ИначеЕсли Получатель = Перечисления.ТипыСтатейАктивовПассивов.СтатьяПассивов Тогда
		
		СписокВыбора.Добавить(Перечисления.ТипыСтатейАктивовПассивов.СтатьяПассивов, НСтр("ru = 'уменьшение других пассивов'"));
		СписокВыбора.Добавить(Перечисления.ТипыСтатейАктивовПассивов.СтатьяРасходов, НСтр("ru = 'возникновение расходов'"));
		СписокВыбора.Добавить(Перечисления.ТипыСтатейАктивовПассивов.СтатьяДоходов,  НСтр("ru = 'уменьшение доходов'"));
		Объект.Получатель = СписокВыбора[0].Значение;
		
	КонецЕсли;
	
КонецПроцедуры

// СтандартныеПодсистемы.Свойства 

&НаСервере
Процедура СвойстваВыполнитьОтложеннуюИнициализацию()
	УправлениеСвойствами.ЗаполнитьДополнительныеРеквизитыВФорме(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()

	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма);

КонецПроцедуры

#КонецОбласти
